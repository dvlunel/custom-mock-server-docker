# Custom Mock Server via Docker

This repository provides a customizable mock server using Docker, enabling simulation of various endpoints for testing and development purposes.

## Features

- **Customizable Endpoints**: Define and simulate multiple endpoints by configuring JSON files.
- **Dockerized Environment**: Easily deploy the mock server using Docker.
- **Convenient Control Script**: Manage the server using `run.sh` for starting, stopping, and monitoring logs.

## Prerequisites

- [Docker](https://www.docker.com/get-started)
- [Docker Compose](https://docs.docker.com/compose/install/)

## Getting Started

1. **Clone the Repository**:

   ```bash
   git clone https://github.com/dvlunel/custom-mock-server-docker.git
   cd custom-mock-server-docker
   ```

2. **Run the Mock Server**:

   Use the provided `run.sh` script to start the mock server:

   ```bash
   ./run.sh start
   ```

   The mock server will be accessible at `http://localhost:1080`.

## Usage

The `run.sh` script provides several commands for managing the mock server:

```bash
./run.sh {start|stop|restart|logs|status}
```

- **`start`**: Merges mock JSON files and starts the server.
- **`stop`**: Stops the running server.
- **`restart`**: Restarts the server, merging JSON files again.
- **`logs`**: Displays logs from the running mock server.
- **`status`**: Checks if the mock server is currently running.

## Customization

- **Adding New Endpoints**: Create additional JSON files in the `config` directory. Then, restart the server using:

  ```bash
  ./run.sh restart
  ```

- **Modifying Existing Endpoints**: Edit the corresponding JSON files in the `config` directory and restart the server.

## Notes

- Ensure that all JSON files in the `config` directory are properly formatted to avoid errors during the merge process.
- The mock server listens on port `1080` by default. You can change this by modifying the `docker-compose.yml` file.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

*This README was generated based on the contents of the `custom-mock-server-docker` repository.*
