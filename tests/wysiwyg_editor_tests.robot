*** Settings ***
Documentation       WYSIWYG Editor tests — verifies the TinyMCE rich text editor can be interacted with.
...                 Typing tests drive the real keyboard. When the hosted TinyMCE is locked
...                 into read-only mode they skip rather than pass, because there is no
...                 honest way to exercise typing against a read-only editor.

Resource            ../resources/common.resource
Resource            ../resources/variables/global_variables.resource
Resource            ../resources/keywords/wysiwyg_editor_keywords.resource

Suite Setup         New Browser    ${BROWSER}    headless=${HEADLESS}
Suite Teardown      Close Browser

Test Setup          New Context
Test Teardown       Close Context

Test Tags           frames    javascript    wysiwyg


*** Test Cases ***
WYSIWYG Editor Page Loads
    [Documentation]    Verifies the WYSIWYG editor page loads with the TinyMCE iframe visible.
    [Tags]    smoke
    Open WYSIWYG Editor Page
    Wait For Elements State    ${IFRAME}    visible

Type Text In WYSIWYG Editor
    [Documentation]    Verifies text typed on the keyboard is entered into the TinyMCE editor.
    [Tags]    smoke
    Open WYSIWYG Editor Page
    Skip Test If Editor Is Read Only
    Clear And Type In Editor    Hello from Robot Framework
    Verify Editor Contains Text    Hello from Robot Framework

Clear And Replace Editor Content
    [Documentation]    Verifies retyping replaces the previous content instead of appending to it.
    [Tags]    regression
    Open WYSIWYG Editor Page
    Skip Test If Editor Is Read Only
    Clear And Type In Editor    First content
    Verify Editor Contains Text    First content
    Clear And Type In Editor    Second content
    Verify Editor Contains Text    Second content
    Verify Editor Does Not Contain Text    First content

Editor Retains Typed Content
    [Documentation]    Verifies editor content persists after typing without navigating away.
    [Tags]    regression
    Open WYSIWYG Editor Page
    Skip Test If Editor Is Read Only
    Clear And Type In Editor    Persistent text
    ${text}=    Get Editor Text
    Should Contain    ${text}    Persistent text
