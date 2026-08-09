# The Internet Test Automation

This project contains automated tests for [The Internet](https://the-internet.herokuapp.com/) using **Robot Framework** and **Playwright** (Browser Library).

## Prerequisites

-   Python 3.8+
-   Node.js 14+

## Installation

1.  **Clone the repository**:
    ```bash
    git clone <repository_url>
    cd the-internet-test-automation
    ```

2.  **Create and activate a virtual environment**:
    ```bash
    python3 -m venv .venv
    source .venv/bin/activate
    ```

3.  **Install dependencies**:
    ```bash
    pip install -r requirements.txt
    ```

4.  **Initialize Playwright browsers**:
    ```bash
    rfbrowser init
    ```

## Running Tests

To run the whole suite:

```bash
robot tests/
```

To run a single suite (e.g. the cross-browser login tests):

```bash
robot tests/login_cross_browser_tests.robot
```



To generate beautiful reports, you first need to install Allure.

**Mac (Homebrew):**
```bash
brew install allure
```

**Generate Reports:**


1.  Run tests with Allure listener:
    ```bash
    robot --listener allure_robotframework:allure_results tests/
    ```
2.  Serve the report:
    ```bash
    allure serve allure_results
    ```

### Run in Parallel (Faster)

To run tests in parallel using Pabot:

```bash
pabot --testlevelsplit tests/
```

### Run with Docker (Recommended)

To run tests in a containerized environment (ensures consistency):

```bash
# Run tests
docker-compose up --build
```


## Structure

-   `tests/`: Contains test suites (`.robot` files).
-   `resources/`: Contains shared keywords, locators, and variables.
    -   `keywords/`: Higher-level keywords.
    -   `locators/`: UI element locators.
    -   `variables/`: Global configuration and test data.
    -   `environments/`: Environment-specific config files.

## Environment Configuration

The application under test, [the-internet](https://the-internet.herokuapp.com/), is a
single public deployment — it has no dev or staging tier. So there is exactly one
environment file, and it is the one CI actually runs:

```bash
pabot --testlevelsplit --variablefile resources/environments/prod.yaml tests/
```

To add an environment, copy `resources/environments/example.yaml.template` to
`<name>.yaml` and pass it with `--variablefile`. Overriding `BASE_URL` is enough —
every `URL_*` in `resources/variables/global_variables.resource` is derived from it,
so all pages follow the selected environment.

Environment files should point at hosts that exist. A `dev.yaml` aimed at a
non-existent server is worse than no file at all: it implies coverage that was never
run. Credentials belong in the CI secret store rather than in version control
(`--variable PASSWORD:%{APP_PASSWORD}`); they are committed here only because this
demo site publishes its own logins.
