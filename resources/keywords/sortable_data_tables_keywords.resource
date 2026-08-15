*** Settings ***
Documentation       Sortable Data Tables Keywords

Resource            ../common.resource
Resource            ../locators/sortable_data_tables_locators.resource
Resource            ../variables/global_variables.resource

Library             Collections


*** Keywords ***
Open Sortable Data Tables Page
    [Documentation]    Opens the browser and navigates to the sortable data tables page.
    New Page    ${URL_TABLES}

Sort Table By Column
    [Documentation]    Clicks a table column header link to sort by that column.
    [Arguments]    ${header_locator}
    Click    ${header_locator}

Get Column Values
    [Documentation]    Returns the values of the given 1-based column of table 1, in row order.
    [Arguments]    ${column_index}
    # Two notes on this snippet:
    #   - the selector is concatenated rather than built with a JS template literal, because
    #     Robot Framework would try to resolve a literal ${...} inside it;
    #   - with a ${None} selector, ``arg`` arrives as the function's *first* parameter.
    ${values}=    Evaluate JavaScript    ${None}
    ...    (n) => Array.from(document.querySelectorAll('#table1 tbody tr td:nth-child(' + n + ')'))
    ...    .map(cell => cell.textContent.trim())
    ...    arg=${column_index}
    RETURN    ${values}

Verify Column Is Sorted
    [Documentation]    Verifies the given column is in the expected order.
    ...                Compares the column against a locally sorted copy of itself, so the
    ...                assertion stays honest if the site's demo data ever changes.
    [Arguments]    ${column_index}    ${direction}=ascending
    ${reverse}=    Evaluate    $direction == 'descending'
    ${values}=    Get Column Values    ${column_index}
    ${expected}=    Evaluate    sorted($values, key=str.lower, reverse=$reverse)
    Lists Should Be Equal    ${values}    ${expected}
    ...    msg=Column ${column_index} is not sorted ${direction}

Wait Until Column Is Sorted
    [Documentation]    Waits for the column to reach the expected order.
    ...                tablesorter reorders the rows asynchronously after the click, so
    ...                reading the DOM immediately after clicking races the sort.
    [Arguments]    ${column_index}    ${direction}=ascending
    Wait Until Keyword Succeeds    10x    500ms
    ...    Verify Column Is Sorted    ${column_index}    ${direction}

Get First Row Last Name
    [Documentation]    Returns the last name from the first row of table 1.
    ${text}=    Get Text    ${TABLE_1_FIRST_ROW_LAST}
    RETURN    ${text}

Get First Row First Name
    [Documentation]    Returns the first name from the first row of table 1.
    ${text}=    Get Text    ${TABLE_1_FIRST_ROW_FIRST}
    RETURN    ${text}

Verify Table Has Rows
    [Documentation]    Verifies table 1 contains the four demo data rows.
    ${count}=    Get Element Count    ${TABLE_1_ROWS}
    Should Be Equal As Integers    ${count}    4
    ...    msg=table1 should render the four demo rows
