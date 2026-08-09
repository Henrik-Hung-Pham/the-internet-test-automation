*** Settings ***
Documentation       Dynamic Content Keywords

Resource            ../common.resource
Resource            ../locators/dynamic_content_locators.resource
Resource            ../variables/global_variables.resource


*** Keywords ***
Open Dynamic Content Page
    [Documentation]    Opens the browser and navigates to the dynamic content page.
    New Page    ${URL_DYNAMIC_CONTENT}

Verify Content Rows Are Present
    [Documentation]    Verifies at least three content rows are rendered on the page.
    ${count}=    Get Element Count    ${CONTENT_ROWS}
    Should Be True    ${count} >= 3

Verify Content Images Are Present
    [Documentation]    Verifies each content row has an accompanying image.
    ${count}=    Get Element Count    ${CONTENT_IMAGES}
    Should Be True    ${count} >= 3

Get Row Text
    [Documentation]    Returns the text content of the nth content row (1-based).
    [Arguments]    ${row_index}
    ${text}=    Get Text    div#content div.row:nth-child(${row_index}) div.large-10
    RETURN    ${text}

Reload Until Row Text Changes
    [Documentation]    Reloads the page until the given row renders different text.
    ...                The page regenerates its content per request, so a reload is expected
    ...                to change the text — but the source data is a small fixed pool, so an
    ...                occasional repeat is normal and only a persistent repeat is a failure.
    [Arguments]    ${row_index}    ${original_text}    ${attempts}=5
    Wait Until Keyword Succeeds    ${attempts}x    0s
    ...    Reload And Verify Row Text Differs    ${row_index}    ${original_text}

Reload And Verify Row Text Differs
    [Documentation]    Reloads the page once and asserts the row no longer shows the old text.
    [Arguments]    ${row_index}    ${original_text}
    Reload
    Wait For Load State    load    timeout=30s
    ${new_text}=    Get Row Text    ${row_index}
    Should Not Be Equal    ${new_text}    ${original_text}
    ...    msg=Row ${row_index} still shows the same text after reloading
