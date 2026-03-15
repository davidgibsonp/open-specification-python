"""Entry point for openspec_python_template."""

from __future__ import annotations

import sys

from loguru import logger


def setup_logging(level: str = "INFO") -> None:
    """Configure loguru logging.

    Args:
        level: Log level string (DEBUG, INFO, WARNING, ERROR).
    """
    logger.remove()
    logger.add(
        sys.stderr,
        format=(
            "<green>{time:HH:mm:ss}</green> | <level>{level: <8}</level> | "
            "<cyan>{name}</cyan>:<cyan>{function}</cyan>:<cyan>{line}</cyan> - "
            "<level>{message}</level>"
        ),
        colorize=True,
        level=level,
    )


def main() -> None:
    """Application entry point."""
    from openspec_python_template.config import get_settings

    settings = get_settings()
    setup_logging(settings.log_level)
    logger.info("Starting openspec_python_template v{}", "0.1.0")
    # TODO: Application logic here


if __name__ == "__main__":
    main()
