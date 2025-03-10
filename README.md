# Custom Mock Server via Docker

This repository provides a customizable mock server using Docker, enabling simulation of various endpoints for testing and development purposes.

## Features

- **Customizable Endpoints**: Define and simulate multiple endpoints by configuring JSON files.
- **Dockerized Environment**: Easily deploy the mock server using Docker Compose.
- **Dynamic Endpoint Merging**: Combine multiple endpoint configurations into a single mock server instance.

## Prerequisites

- [Docker](https://www.docker.com/get-started)
- [Docker Compose](https://docs.docker.com/compose/install/)

## Getting Started

1. **Clone the Repository**:

   ```bash
   git clone https://github.com/dvlunel/custom-mock-server-docker.git
   cd custom-mock-server-docker
   ```

2. **Configure Endpoints**:

   Place your JSON configuration files defining the desired endpoints into the `config` directory. Each JSON file should specify the endpoints and their corresponding responses.

3. **Merge Endpoint Configurations**:

   Run the provided script to merge all JSON configurations into a single file:

   ```bash
   ./merge_mocks.sh
   ```

   This script concatenates all JSON files in the `config` directory into a single `endpoints.json` file.

4. **Start the Mock Server**:

   Use Docker Compose to build and run the mock server:

   ```bash
   docker-compose up --build
   ```

   The mock server will be accessible at `http://localhost:1080`.

## Usage

Once the server is running, you can send HTTP requests to the defined endpoints. The server will respond based on the configurations specified in your JSON files.

## Stopping the Server

To stop the mock server, press `CTRL+C` in the terminal where Docker Compose is running, or execute:

```bash
docker-compose down
```

## Customization

- **Adding New Endpoints**: To add new endpoints, create additional JSON files in the `config` directory and re-run the `merge_mocks.sh` script. Then, restart the server using Docker Compose.
- **Modifying Existing Endpoints**: Edit the corresponding JSON files in the `config` directory, merge the configurations, and restart the server.

## Notes

- Ensure that all JSON files in the `config` directory are properly formatted to avoid errors during the merge process.
- The mock server listens on port `1080` by default. You can change this by modifying the `docker-compose.yml` file.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

*This README was generated based on the contents of the `custom-mock-server-docker` repository.*
