"""Application settings loaded from environment variables / .env file."""

from __future__ import annotations

from functools import lru_cache

from pydantic import Field
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    """Application configuration.

    All fields are read from environment variables prefixed with ``OPENSPEC_``
    (e.g. ``OPENSPEC_DEBUG``) or from a ``.env`` file in the project root.
    """

    model_config = SettingsConfigDict(
        env_prefix="OPENSPEC_",
        env_file=".env",
        env_file_encoding="utf-8",
    )

    # Application
    debug: bool = Field(default=False, description="Enable debug mode")
    log_level: str = Field(
        default="INFO", description="Logging level (DEBUG, INFO, WARNING, ERROR)"
    )

    # TODO: Add project-specific settings below
    # database_url: str = Field(description="Database connection string")
    # api_key: str = Field(description="External API key")


@lru_cache(maxsize=1)
def get_settings() -> Settings:
    """Return a cached Settings instance."""
    return Settings()
