*** Settings ***
Documentation       Shadow DOM tests — verifies text content inside Web Component shadow DOM elements.

Resource            ../resources/common.resource
Resource            ../resources/variables/global_variables.resource
Resource            ../resources/keywords/shadow_dom_keywords.resource

Suite Setup         New Browser    ${BROWSER}    headless=${HEADLESS}
Suite Teardown      Close Browser

Test Setup          New Context
Test Teardown       Close Context

Test Tags           javascript    shadow-dom


*** Test Cases ***
Shadow DOM Page Loads
    [Documentation]    Verifies the shadow DOM page renders both custom element hosts.
    [Tags]    regression
    Open Shadow DOM Page
    ${count}=    Get Element Count    my-paragraph
    Should Be Equal As Integers    ${count}    2
    ...    msg=The shadow DOM example should render two my-paragraph hosts

First Shadow Host Contains Expected Text
    [Documentation]    Verifies the first shadow DOM element contains the expected paragraph text.
    [Tags]    smoke
    Open Shadow DOM Page
    Verify Shadow DOM Contains Text    1    Let's have

Second Shadow Host Contains Expected Text
    [Documentation]    Verifies the second shadow DOM element contains expected paragraph text.
    [Tags]    regression
    Open Shadow DOM Page
    Verify Shadow DOM Contains Text    2    Let's have some different text
