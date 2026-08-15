*** Settings ***
Documentation       File Download tests — verifies downloadable file links are present and functional.

Resource            ../resources/common.resource
Resource            ../resources/variables/global_variables.resource
Resource            ../resources/keywords/file_download_keywords.resource

Suite Setup         New Browser    ${BROWSER}    headless=${HEADLESS}
Suite Teardown      Close Browser

Test Setup          New Context
Test Teardown       Close Context

Test Tags           navigation    file-download


*** Test Cases ***
File Download Page Has Download Links
    [Documentation]    Verifies at least one downloadable file link is available.
    [Tags]    regression
    Open File Download Page
    Verify Download Links Are Present

First Download Link Points At The File It Names
    [Documentation]    Verifies the link text is the filename it actually links to, rather
    ...                than merely being non-empty.
    [Tags]    smoke
    Open File Download Page
    ${text}=    Get First Download Link Text
    ${href}=    Get First Download Link Href
    Should Not Be Empty    ${text}
    Should End With    ${href}    /download/${text}
    ...    msg=Link text "${text}" does not match its href ${href}

Downloaded File Is Written To Disk
    [Documentation]    Verifies clicking a download link produces a real, non-empty file saved
    ...                under the advertised filename — not merely that a download event fired.
    [Tags]    regression
    Open File Download Page
    ${expected_filename}=    Get First Download Link Text
    ${file_info}=    Download First File
    Verify Downloaded File Is On Disk    ${file_info}    ${expected_filename}
