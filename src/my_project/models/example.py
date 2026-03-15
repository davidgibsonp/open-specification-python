"""Example domain model demonstrating Pydantic patterns.

This is a golden example -- new models should follow this pattern.
"""

from __future__ import annotations

from pydantic import BaseModel, Field


class ExampleItem(BaseModel):
    """An example domain entity.

    Every field uses ``Field(description=...)`` so AI agents and
    ``model_json_schema()`` can introspect the model's intent.
    """

    name: str = Field(description="Human-readable name of the item")
    value: int = Field(ge=0, description="Non-negative integer value")
    tags: list[str] = Field(default_factory=list, description="Optional categorization tags")

    def display_name(self) -> str:
        """Return formatted display name with tag count.

        Returns:
            Formatted string like 'ItemName (3 tags)'.
        """
        return f"{self.name} ({len(self.tags)} tags)"
