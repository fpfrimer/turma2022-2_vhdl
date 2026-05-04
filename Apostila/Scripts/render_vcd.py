#!/usr/bin/env python3
"""Render scalar VCD signals as a PNG timing diagram.

Example:
    python Scripts/render_vcd.py onda_and.vcd Imagens/onda_and.png \
        --signals tb_and2.a tb_and2.b tb_and2.y \
        --labels A B Y \
        --title "Simulacao da porta AND" \
        --end 40
"""

from __future__ import annotations

import argparse
from pathlib import Path

import matplotlib.pyplot as plt


TIME_UNITS_TO_NS = {
    "s": 1_000_000_000,
    "ms": 1_000_000,
    "us": 1_000,
    "ns": 1,
    "ps": 0.001,
    "fs": 0.000001,
}


def parse_timescale(line: str) -> float:
    parts = line.replace("$timescale", "").replace("$end", "").split()
    if len(parts) < 2:
        return 1.0
    amount = float(parts[0])
    unit = parts[1]
    return amount * TIME_UNITS_TO_NS.get(unit, 1.0)


def signal_matches(full_name: str, requested: str) -> bool:
    return full_name == requested or full_name.endswith("." + requested)


def parse_vcd(path: Path, requested_signals: list[str]) -> tuple[dict[str, list[tuple[float, str]]], float | None]:
    symbol_to_name: dict[str, str] = {}
    selected: dict[str, str] = {}
    values = {signal: [(0.0, "0")] for signal in requested_signals}

    scope: list[str] = []
    current_time = 0.0
    time_factor_ns = 1.0
    max_time: float | None = None
    in_defs = True

    for raw in path.read_text().splitlines():
        line = raw.strip()
        if not line:
            continue

        if line.startswith("$timescale"):
            time_factor_ns = parse_timescale(line)
            continue

        if line.startswith("$scope"):
            parts = line.split()
            if len(parts) >= 3:
                scope.append(parts[2])
            continue

        if line.startswith("$upscope"):
            if scope:
                scope.pop()
            continue

        if line == "$enddefinitions $end":
            in_defs = False
            continue

        if in_defs and line.startswith("$var"):
            parts = line.split()
            if len(parts) < 5:
                continue
            width = parts[2]
            symbol = parts[3]
            local_name = parts[4]
            full_name = ".".join(scope + [local_name])
            symbol_to_name[symbol] = full_name
            if width != "1":
                continue
            for requested in requested_signals:
                if requested not in selected and signal_matches(full_name, requested):
                    selected[requested] = symbol
            continue

        if line.startswith("#"):
            current_time = int(line[1:]) * time_factor_ns
            max_time = current_time
            continue

        if in_defs or not line:
            continue

        value = line[0]
        symbol = line[1:]
        for requested, selected_symbol in selected.items():
            if symbol == selected_symbol and value in {"0", "1", "x", "X", "z", "Z"}:
                values[requested].append((current_time, value.lower()))

    missing = [signal for signal in requested_signals if signal not in selected]
    if missing:
        available = "\n".join(sorted(symbol_to_name.values()))
        raise SystemExit(
            "Signals not found: "
            + ", ".join(missing)
            + "\n\nAvailable signals:\n"
            + available
        )

    return values, max_time


def value_height(value: str) -> float:
    if value == "1":
        return 0.55
    if value == "0":
        return 0.05
    return 0.3


def render(
    values: dict[str, list[tuple[float, str]]],
    output: Path,
    labels: list[str],
    title: str,
    end_time: float | None,
) -> None:
    signal_count = len(values)
    height = max(2.4, 0.75 * signal_count + 0.9)
    fig, ax = plt.subplots(figsize=(8, height), dpi=180)

    if end_time is None:
        end_time = max((points[-1][0] for points in values.values() if points), default=1.0)

    for index, (signal, points) in enumerate(values.items()):
        base = signal_count - index - 1
        xs: list[float] = []
        ys: list[float] = []
        for point_index, (time_ns, value) in enumerate(points):
            y = base + value_height(value)
            if point_index == 0:
                xs.append(time_ns)
                ys.append(y)
            else:
                xs.extend([time_ns, time_ns])
                ys.extend([ys[-1], y])
        xs.append(end_time)
        ys.append(ys[-1])
        ax.plot(xs, ys, drawstyle="steps-post", color="#004987", linewidth=2.2)
        ax.text(
            -0.06 * end_time,
            base + 0.3,
            labels[index],
            ha="right",
            va="center",
            fontsize=11,
            fontweight="bold",
        )

    ax.set_xlim(0, end_time)
    ax.set_ylim(-0.3, signal_count - 0.1)
    ax.set_xlabel("Tempo (ns)")
    ax.set_yticks([])
    ax.grid(axis="x", linestyle=":", color="#bbbbbb")
    ax.set_title(title, fontsize=12, pad=10)
    for spine in ["left", "right", "top"]:
        ax.spines[spine].set_visible(False)

    fig.tight_layout()
    output.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(output, bbox_inches="tight")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("vcd", type=Path, help="Input VCD file")
    parser.add_argument("output", type=Path, help="Output PNG file")
    parser.add_argument("--signals", nargs="+", required=True, help="Signals to render")
    parser.add_argument("--labels", nargs="+", help="Labels shown in the image")
    parser.add_argument("--title", default="Simulacao", help="Figure title")
    parser.add_argument("--end", type=float, help="End time in ns")
    args = parser.parse_args()

    labels = args.labels or [signal.split(".")[-1].upper() for signal in args.signals]
    if len(labels) != len(args.signals):
        raise SystemExit("--labels must have the same number of items as --signals")

    values, detected_end = parse_vcd(args.vcd, args.signals)
    render(values, args.output, labels, args.title, args.end or detected_end)


if __name__ == "__main__":
    main()
