*** Settings ***
Documentation       WYSIWYG Editor Keywords
...                 Editor interaction is delegated to the shared TinyMCE keywords so both
...                 /iframe and /tinymce drive the widget the same (real-UI) way.

Resource            ../common.resource
Resource            ../locators/wysiwyg_editor_locators.resource
Resource            ../variables/global_variables.resource
Resource            tinymce_keywords.resource


*** Keywords ***
Open WYSIWYG Editor Page
    [Documentation]    Opens the browser and navigates to the WYSIWYG editor page.
    New Page    ${URL_WYSIWYG_EDITOR}
    Wait Until TinyMCE Is Ready

Clear And Type In Editor
    [Documentation]    Replaces the editor content by typing over it on the real keyboard.
    [Arguments]    ${text}
    Type In Editor    ${text}
