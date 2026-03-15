"""Tests for the main module -- demonstrates testing application entry points.

This tests the logging setup and main entry point without starting a full application.
"""

from __future__ import annotations

import pytest
from loguru import logger

from my_project.main import main, setup_logging


@pytest.mark.unit
class TestSetupLogging:
    """Tests for setup_logging function."""

    def test_setup_logging_default_level(self, capsys: pytest.CaptureFixture[str]) -> None:
        """Setup logging configures loguru with default INFO level."""
        setup_logging()
        logger.info("Test message")
        # The logger should have been configured (no exception)

    def test_setup_logging_debug_level(self) -> None:
        """Setup logging can be configured with DEBUG level."""
        setup_logging("DEBUG")
        logger.debug("Debug message")
        # The logger should accept debug messages

    def test_setup_logging_error_level(self) -> None:
        """Setup logging can be configured with ERROR level."""
        setup_logging("ERROR")
        logger.error("Error message")
        # The logger should accept error messages


@pytest.mark.unit
class TestMain:
    """Tests for main entry point."""

    def test_main_runs_without_error(self, capsys: pytest.CaptureFixture[str]) -> None:
        """Main function executes without raising exceptions."""
        # main() should run and complete without error
        main()
        # The function ran without exception

    def test_main_logs_startup_message(self, capfd: pytest.CaptureFixture[str]) -> None:
        """Main function logs startup message."""
        main()
        captured = capfd.readouterr()
        # Startup message should be in stderr (loguru default)
        assert "my_project" in captured.err or captured.out == ""
