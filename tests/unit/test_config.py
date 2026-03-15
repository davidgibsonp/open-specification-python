"""Tests for the config module -- demonstrates testing Pydantic settings.

Tests ensure the configuration system works correctly with environment variables
and defaults.
"""

from __future__ import annotations

import pytest

from my_project.config import Settings, get_settings


@pytest.mark.unit
class TestSettings:
    """Tests for Settings configuration class."""

    def test_settings_default_values(self) -> None:
        """Settings have correct default values."""
        settings = Settings()
        assert settings.debug is False
        assert settings.log_level == "INFO"

    def test_settings_debug_from_env(self, monkeypatch: pytest.MonkeyPatch) -> None:
        """Debug setting can be loaded from environment variable."""
        monkeypatch.setenv("MY_PROJECT_DEBUG", "true")
        settings = Settings()
        assert settings.debug is True

    def test_settings_log_level_from_env(self, monkeypatch: pytest.MonkeyPatch) -> None:
        """Log level can be loaded from environment variable."""
        monkeypatch.setenv("MY_PROJECT_LOG_LEVEL", "DEBUG")
        settings = Settings()
        assert settings.log_level == "DEBUG"


@pytest.mark.unit
class TestGetSettings:
    """Tests for get_settings function."""

    def test_get_settings_returns_settings(self) -> None:
        """get_settings returns a Settings instance."""
        settings = get_settings()
        assert isinstance(settings, Settings)

    def test_get_settings_cached(self) -> None:
        """get_settings returns the same cached instance on repeated calls."""
        # Clear any existing cache
        get_settings.cache_clear()
        settings1 = get_settings()
        settings2 = get_settings()
        assert settings1 is settings2
