*** Settings ***
Documentation       File Upload Keywords

Resource            ../common.resource
Resource            ../locators/file_upload_locators.resource
Resource            ../variables/global_variables.resource


*** Keywords ***
Open File Upload Page
    [Documentation]    Opens the browser and navigates to the file upload page.
    New Page    ${URL_FILE_UPLOAD}

Upload File
    [Documentation]    Uploads a file using the file input element.
    [Arguments]    ${file_path}
    Upload File By Selector    ${FILE_INPUT}    ${file_path}
    Click    ${SUBMIT_BUTTON}

Verify Uploaded Filename
    [Documentation]    Verifies the uploaded filename is displayed on the page.
    [Arguments]    ${expected_filename}
    Wait For Elements State    ${UPLOADED_FILES}    visible    timeout=10s
    Get Text    ${UPLOADED_FILES}    *=    ${expected_filename}

Create Temporary Text File
    [Documentation]    Creates a temporary .txt file with sample content and returns its path.
    ...                The mkstemp file descriptor is closed so the file can be reopened on Windows.
    [Arguments]    ${prefix}=rf_upload_    ${content}=Robot Framework upload test
    ${fd}    ${temp_file}=    Evaluate    tempfile.mkstemp(suffix='.txt', prefix=$prefix)    modules=tempfile
    Evaluate    os.close($fd)    modules=os
    Evaluate    open($temp_file, 'w').write($content)
    RETURN    ${temp_file}

Remove Temporary File
    [Documentation]    Deletes the given temporary file from disk.
    [Arguments]    ${file_path}
    Evaluate    os.remove($file_path)    modules=os
