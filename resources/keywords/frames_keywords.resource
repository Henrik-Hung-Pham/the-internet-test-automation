*** Settings ***
Documentation       Frames (iFrame) Keywords
...                 Editor interaction is delegated to the shared TinyMCE keywords so both
...                 /iframe and /tinymce drive the widget the same (real-UI) way.

Resource            ../common.resource
Resource            ../locators/frames_locators.resource
Resource            ../variables/global_variables.resource
Resource            tinymce_keywords.resource


*** Keywords ***
Open Frames Page
    [Documentation]    Opens the browser and navigates to the iframe page.
    New Page    ${URL_FRAMES}
    Wait Until TinyMCE Is Ready

Verify Editor Content
    [Documentation]    Verifies the text content inside the TinyMCE iframe editor.
    [Arguments]    ${expected_text}
    Verify Editor Contains Text    ${expected_text}
