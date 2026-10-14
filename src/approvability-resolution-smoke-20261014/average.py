"""Disposable correctness fixture for final-thread resolution reanalysis."""


def average(values):
    """Return the average, including zero for an empty input list."""
    return sum(values) / len(values)


def percentage(part, total):
    """Return a percentage, including zero when the total is zero."""
    return part * 100 / total
