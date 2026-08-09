*** Settings ***
Documentation       Shared TinyMCE Keywords
...                 Real-UI primitives for the TinyMCE editor that the-internet serves on
...                 both /iframe and /tinymce. Input goes through the keyboard and the DOM,
...                 never through the ``tinymce`` JavaScript API — a test that sets content
...                 with ``editor.getBody().innerHTML`` and then reads it back through the
...                 same API passes even when the editor is completely unusable.

Resource            ../common.resource
Resource            ../locators/tinymce_locators.resource


*** Keywords ***
Wait Until TinyMCE Is Ready
    [Documentation]    Waits for the iframe and for TinyMCE to report that it has initialised.
    Wait For Load State    networkidle    timeout=30s
    Wait For Elements State    ${TINYMCE_IFRAME}    visible    timeout=30s
    Wait Until Keyword Succeeds    30x    1s    Verify TinyMCE Is Initialized

Verify TinyMCE Is Initialized
    [Documentation]    Verifies TinyMCE is fully initialised and its body is ready.
    ${ready}=    Evaluate JavaScript    ${None}
    ...    () => !!(window.tinymce && tinymce.activeEditor && tinymce.activeEditor.initialized)
    Should Be True    ${ready}    TinyMCE not yet initialized

Get Editor Mode
    [Documentation]    Returns the editor's current mode — ``design`` when editable,
    ...                ``readonly`` when TinyMCE has locked it.
    ${mode}=    Evaluate JavaScript    ${None}
    ...    () => (window.tinymce && tinymce.activeEditor && tinymce.activeEditor.mode)
    ...    ? tinymce.activeEditor.mode.get() : 'unknown'
    RETURN    ${mode}

Get Editor Read Only Reason
    [Documentation]    Returns the notification text TinyMCE shows when it locks the editor,
    ...                or an empty string when there is no notification.
    ${count}=    Get Element Count    ${TINYMCE_NOTIFICATION}
    IF    ${count} == 0    RETURN    ${EMPTY}
    ${reason}=    Get Text    ${TINYMCE_NOTIFICATION}
    RETURN    ${reason}

Skip Test If Editor Is Read Only
    [Documentation]    Skips the calling test when the hosted TinyMCE is in read-only mode.
    ...                the-internet uses TinyMCE Cloud, which locks the editor once the
    ...                site owner's monthly editor-load quota is exhausted. Typing genuinely
    ...                cannot be exercised in that state, so the test is skipped rather than
    ...                passed against a faked input path.
    ${mode}=    Get Editor Mode
    IF    '${mode}' != 'design'
        ${reason}=    Get Editor Read Only Reason
        Skip    Hosted TinyMCE is not editable (mode=${mode}). ${reason}
    END

Type In Editor
    [Documentation]    Replaces the editor content by typing on the real keyboard —
    ...                clicks into the editor body, selects everything, and types over it.
    [Arguments]    ${text}
    Click    ${TINYMCE_BODY}
    Keyboard Key    press    ControlOrMeta+a
    Keyboard Input    type    ${text}

Get Editor Text
    [Documentation]    Returns the editor's visible text, read from the DOM inside the iframe
    ...                rather than from the ``tinymce`` API that the input path would use.
    ${text}=    Get Text    ${TINYMCE_BODY}
    RETURN    ${text}

Verify Editor Contains Text
    [Documentation]    Verifies the editor body contains the expected text.
    [Arguments]    ${expected_text}
    ${content}=    Get Editor Text
    Should Contain    ${content}    ${expected_text}

Verify Editor Does Not Contain Text
    [Documentation]    Verifies the expected text is absent — used to prove a retype
    ...                actually replaced the previous content instead of appending to it.
    [Arguments]    ${unexpected_text}
    ${content}=    Get Editor Text
    Should Not Contain    ${content}    ${unexpected_text}
