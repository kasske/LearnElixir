# Raffley 🎟️

A real-time raffle application built with Elixir and Phoenix LiveView. This project demonstrates modern web development patterns including real-time user presence, live updates, and interactive UI components.

## Features

- **Real-time Raffles**: Create and manage charity raffles with live updates
- **User Authentication**: Secure user registration and login system
- **Live Presence**: See who's currently viewing each raffle in real-time
- **Admin Dashboard**: Administrative interface for managing raffles and drawing winners
- **Ticket System**: Users can purchase raffle tickets with comments
- **Charity Integration**: Support for multiple charitable organizations
- **Responsive Design**: Modern UI built with Tailwind CSS

## Tech Stack

- **Elixir** - Functional programming language
- **Phoenix Framework** - Web framework for Elixir
- **Phoenix LiveView** - Real-time, interactive web applications
- **Phoenix PubSub** - Real-time messaging and presence tracking
- **Ecto** - Database wrapper and query generator
- **PostgreSQL** - Database
- **Tailwind CSS** - Utility-first CSS framework

## Getting Started

### Prerequisites

- Elixir 1.16+ 
- Phoenix 1.7+
- PostgreSQL
- Node.js (for asset compilation)

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   mix setup
   ```
3. Start the Phoenix server:
   ```bash
   mix phx.server
   ```
   Or inside IEx:
   ```bash
   iex -S mix phx.server
   ```

4. Visit [`localhost:4000`](http://localhost:4000) from your browser

### Database Setup

The `mix setup` command will:
- Install Hex and Rebar dependencies
- Create and migrate the database
- Install Node.js dependencies for assets
- Run database seeds

## Project Structure

- `lib/raffley/` - Core business logic and contexts
  - `accounts/` - User authentication and management
  - `raffles/` - Raffle management and operations
  - `charities/` - Charity organization handling
- `lib/raffley_web/` - Web interface and LiveView components
  - `live/` - Phoenix LiveView modules
  - `channels/` - WebSocket channels and presence
  - `components/` - Reusable UI components
- `priv/repo/migrations/` - Database migrations
- `test/` - Test suite

## Key Learning Concepts

This project was built while learning Elixir and Phoenix, demonstrating:

- **Phoenix LiveView** for real-time, interactive web applications
- **GenServer** and OTP principles for concurrent, fault-tolerant systems
- **Phoenix Presence** for tracking user activity across the application
- **Ecto** for database interactions and data modeling
- **Phoenix Channels** for real-time communication
- **Pattern matching** and functional programming concepts
- **Supervision trees** and fault tolerance

## Deployment

Ready to run in production? Please [check the Phoenix deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn More About Phoenix

- Official website: https://www.phoenixframework.org/
- Guides: https://hexdocs.pm/phoenix/overview.html
- Docs: https://hexdocs.pm/phoenix
- Forum: https://elixirforum.com/c/phoenix-forum
- Source: https://github.com/phoenixframework/phoenix
