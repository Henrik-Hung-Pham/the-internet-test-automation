*** Settings ***
Documentation       Sortable Data Tables tests — verifies sorting table columns and reading cell data.

Resource            ../resources/common.resource
Resource            ../resources/variables/global_variables.resource
Resource            ../resources/keywords/sortable_data_tables_keywords.resource

Suite Setup         New Browser    ${BROWSER}    headless=${HEADLESS}
Suite Teardown      Close Browser

Test Setup          New Context
Test Teardown       Close Context

Test Tags           tables    navigation


*** Test Cases ***
Table 1 Is Present With Data
    [Documentation]    Verifies table 1 is visible and contains its data rows.
    [Tags]    smoke
    Open Sortable Data Tables Page
    Wait For Elements State    ${TABLE_1}    visible
    Verify Table Has Rows

Table 2 Is Present
    [Documentation]    Verifies table 2 is visible on the page.
    [Tags]    smoke
    Open Sortable Data Tables Page
    Wait For Elements State    ${TABLE_2}    visible

Sort By Last Name Orders The Column Ascending
    [Documentation]    Verifies clicking the Last Name header actually orders that column
    ...                ascending, rather than merely leaving a non-empty cell behind.
    [Tags]    smoke
    Open Sortable Data Tables Page
    Sort Table By Column    ${TABLE_1_LAST_NAME_SORT}
    Wait Until Column Is Sorted    1    ascending

Sorting Last Name Twice Reverses The Order
    [Documentation]    Verifies a second click on the same header sorts descending.
    [Tags]    regression
    Open Sortable Data Tables Page
    Sort Table By Column    ${TABLE_1_LAST_NAME_SORT}
    Wait Until Column Is Sorted    1    ascending
    Sort Table By Column    ${TABLE_1_LAST_NAME_SORT}
    Wait Until Column Is Sorted    1    descending

Sort By First Name Orders The Column Ascending
    [Documentation]    Verifies clicking the First Name header re-sorts the table on that column.
    [Tags]    regression
    Open Sortable Data Tables Page
    Sort Table By Column    ${TABLE_1_FIRST_NAME_SORT}
    Wait Until Column Is Sorted    2    ascending

Sorting By A Different Column Changes The First Row
    [Documentation]    Verifies sorting by Last Name and then by First Name leaves the table
    ...                ordered by the most recently clicked column.
    [Tags]    regression
    Open Sortable Data Tables Page
    Sort Table By Column    ${TABLE_1_LAST_NAME_SORT}
    Wait Until Column Is Sorted    1    ascending
    ${last_name_first_row}=    Get First Row Last Name
    Sort Table By Column    ${TABLE_1_FIRST_NAME_SORT}
    Wait Until Column Is Sorted    2    ascending
    ${first_name_first_row}=    Get First Row First Name
    Should Not Be Equal    ${last_name_first_row}    ${first_name_first_row}
    ...    msg=Sorting by a different column should surface a different row first
