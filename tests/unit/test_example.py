"""Tests for the example model -- demonstrates testing patterns.

This is a golden example -- new test files should follow this pattern.
"""

from __future__ import annotations

import pytest

from my_project.models.example import ExampleItem


@pytest.mark.unit
class TestExampleItem:
    """Tests for ExampleItem model."""

    def test_create_with_defaults(self) -> None:
        """Items can be created with only required fields."""
        item = ExampleItem(name="test", value=42)
        assert item.name == "test"
        assert item.value == 42
        assert item.tags == []

    def test_display_name_no_tags(self) -> None:
        """Display name shows zero tag count when no tags provided."""
        item = ExampleItem(name="Widget", value=1)
        assert item.display_name() == "Widget (0 tags)"

    def test_display_name_with_tags(self) -> None:
        """Display name includes accurate tag count."""
        item = ExampleItem(name="Widget", value=1, tags=["a", "b"])
        assert item.display_name() == "Widget (2 tags)"

    def test_negative_value_rejected(self) -> None:
        """Negative values are rejected by validation."""
        with pytest.raises(ValueError, match="greater than or equal to 0"):
            ExampleItem(name="bad", value=-1)
