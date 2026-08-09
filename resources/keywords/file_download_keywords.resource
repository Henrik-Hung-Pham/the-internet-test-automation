*** Settings ***
Documentation       File Download Keywords

Resource            ../common.resource
Resource            ../locators/file_download_locators.resource
Resource            ../variables/global_variables.resource

Library             OperatingSystem


*** Keywords ***
Open File Download Page
    [Documentation]    Opens the browser and navigates to the file download page.
    New Page    ${URL_FILE_DOWNLOAD}

Verify Download Links Are Present
    [Documentation]    Verifies the page lists downloadable files.
    ...                An exact count is deliberately not asserted: the list grows every time
    ...                the file-upload suite runs against the same shared demo site.
    ${count}=    Get Element Count    ${DOWNLOAD_LINKS}
    Should Be True    ${count} > 0    The download page should list at least one file

Get First Download Link Text
    [Documentation]    Returns the text of the first download link.
    ${text}=    Get Text    ${FIRST_LINK}
    RETURN    ${text}

Get First Download Link Href
    [Documentation]    Returns the href of the first download link.
    ${href}=    Get Property    ${FIRST_LINK}    href
    RETURN    ${href}

Download First File
    [Documentation]    Clicks the first file link and waits for the download to finish.
    ${download}=    Promise To Wait For Download
    Click    ${FIRST_LINK}
    ${file_info}=    Wait For    ${download}
    RETURN    ${file_info}

Verify Downloaded File Is On Disk
    [Documentation]    Verifies the download produced a real file: it exists on disk, is not
    ...                empty, and was saved under the filename the link advertised.
    [Arguments]    ${file_info}    ${expected_filename}
    VAR    ${saved_path}    ${file_info}[saveAs]
    File Should Exist    ${saved_path}
    ${size}=    Get File Size    ${saved_path}
    Should Be True    ${size} > 0    Downloaded file ${saved_path} is empty
    Should Be Equal    ${file_info}[suggestedFilename]    ${expected_filename}
    ...    msg=Downloaded file name does not match the link that was clicked
