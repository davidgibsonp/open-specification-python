"""Shared pytest fixtures."""

from __future__ import annotations

import pytest

from my_project.config import Settings


@pytest.fixture
def settings() -> Settings:
    """Provide test settings with safe defaults."""
    return Settings(
        debug=True,
        log_level="DEBUG",
    )
