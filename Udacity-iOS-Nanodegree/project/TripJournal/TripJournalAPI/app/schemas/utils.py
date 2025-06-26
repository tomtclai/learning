from datetime import datetime


def iso8601(dt: datetime) -> str:
    return dt.strftime("%Y-%m-%dT%H:%M:%SZ") if dt else None
