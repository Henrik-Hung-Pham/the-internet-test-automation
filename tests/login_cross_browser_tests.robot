*** Settings ***
Documentation       Login tests across all Playwright browsers (chromium, firefox, webkit).
...                 Data-driven via Test Template — each case supplies the row
...                 [ username | password | expected flash message | browser ].

Library             Browser    timeout=30s
Resource            ../resources/variables/global_variables.resource
Resource            ../resources/keywords/login_keywords.resource

Test Tags           cross-browser
Test Template       Login Scenario


*** Test Cases ***    USERNAME        PASSWORD        EXPECTED MESSAGE                  BROWSER
# --- Chromium ---
Login With Valid Credentials - Chromium
    [Documentation]    Verifies successful login with valid credentials on Chromium.
    [Tags]    smoke    chromium
    ${USERNAME}    ${PASSWORD}    You logged into a secure area!    chromium

Login With Invalid Username - Chromium
    [Documentation]    Verifies the error message when an invalid username is submitted on Chromium.
    [Tags]    regression    chromium
    invalid_user    ${PASSWORD}    Your username is invalid!    chromium

Login With Invalid Password - Chromium
    [Documentation]    Verifies the error message when an invalid password is submitted on Chromium.
    [Tags]    regression    chromium
    ${USERNAME}    invalid_pass    Your password is invalid!    chromium

Login With Empty Username - Chromium
    [Documentation]    Verifies submitting an empty username is rejected on Chromium.
    [Tags]    regression    chromium    negative
    ${EMPTY}    ${PASSWORD}    Your username is invalid!    chromium

Login With Empty Password - Chromium
    [Documentation]    Verifies submitting an empty password is rejected on Chromium.
    [Tags]    regression    chromium    negative
    ${USERNAME}    ${EMPTY}    Your password is invalid!    chromium

# --- Firefox ---
Login With Valid Credentials - Firefox
    [Documentation]    Verifies successful login with valid credentials on Firefox.
    [Tags]    smoke    firefox
    ${USERNAME}    ${PASSWORD}    You logged into a secure area!    firefox

Login With Invalid Username - Firefox
    [Documentation]    Verifies the error message when an invalid username is submitted on Firefox.
    [Tags]    regression    firefox
    invalid_user    ${PASSWORD}    Your username is invalid!    firefox

Login With Invalid Password - Firefox
    [Documentation]    Verifies the error message when an invalid password is submitted on Firefox.
    [Tags]    regression    firefox
    ${USERNAME}    invalid_pass    Your password is invalid!    firefox

# --- WebKit ---
Login With Valid Credentials - WebKit
    [Documentation]    Verifies successful login with valid credentials on WebKit.
    [Tags]    smoke    webkit
    ${USERNAME}    ${PASSWORD}    You logged into a secure area!    webkit

Login With Invalid Username - WebKit
    [Documentation]    Verifies the error message when an invalid username is submitted on WebKit.
    [Tags]    regression    webkit
    invalid_user    ${PASSWORD}    Your username is invalid!    webkit

Login With Invalid Password - WebKit
    [Documentation]    Verifies the error message when an invalid password is submitted on WebKit.
    [Tags]    regression    webkit
    ${USERNAME}    invalid_pass    Your password is invalid!    webkit
