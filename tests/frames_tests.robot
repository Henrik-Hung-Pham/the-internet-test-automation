*** Settings ***
Documentation       Frames (iFrame) tests — verifies interaction with content inside a TinyMCE iframe editor.
...                 Typing tests drive the real keyboard. When the hosted TinyMCE is locked
...                 into read-only mode they skip rather than pass, because there is no
...                 honest way to exercise typing against a read-only editor.

Resource            ../resources/common.resource
Resource            ../resources/variables/global_variables.resource
Resource            ../resources/keywords/frames_keywords.resource

Suite Setup         New Browser    ${BROWSER}    headless=${HEADLESS}
Suite Teardown      Close Browser

Test Setup          New Context
Test Teardown       Close Context

Test Tags           frames    javascript


*** Test Cases ***
IFrame Editor Is Present
    [Documentation]    Verifies the TinyMCE iframe is visible on the page.
    [Tags]    smoke
    Open Frames Page
    Wait For Elements State    ${IFRAME}    visible

Type Text In IFrame Editor
    [Documentation]    Verifies text typed on the keyboard reaches the TinyMCE iframe editor.
    [Tags]    smoke
    Open Frames Page
    Skip Test If Editor Is Read Only
    Type In Editor    Hello from Robot Framework
    Verify Editor Content    Hello from Robot Framework

Clear And Retype In IFrame Editor
    [Documentation]    Verifies retyping replaces the previous content instead of appending to it.
    [Tags]    regression
    Open Frames Page
    Skip Test If Editor Is Read Only
    Type In Editor    Initial text
    Verify Editor Content    Initial text
    Type In Editor    Replaced text
    Verify Editor Content    Replaced text
    Verify Editor Does Not Contain Text    Initial text
