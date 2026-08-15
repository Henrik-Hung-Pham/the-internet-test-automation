*** Settings ***
Documentation       Broken Images tests — verifies the page loads and identifies its broken image resources.

Resource            ../resources/common.resource
Resource            ../resources/variables/global_variables.resource
Resource            ../resources/keywords/broken_images_keywords.resource

Suite Setup         New Browser    ${BROWSER}    headless=${HEADLESS}
Suite Teardown      Close Browser

Test Setup          New Context
Test Teardown       Close Context

Test Tags           navigation    broken-images


*** Test Cases ***
Page Contains Images
    [Documentation]    Verifies the broken images page renders its three image elements.
    [Tags]    regression
    Open Broken Images Page
    Verify Page Has Images

Exactly The Two Known Images Are Broken
    [Documentation]    Verifies which images are broken, not just that some number of them are.
    ...                An assertion of "more than zero broken" would still pass if every
    ...                image on the page broke.
    [Tags]    smoke
    Open Broken Images Page
    Verify Broken Images Are Exactly    asdf.jpg    hjkl.jpg

The Avatar Image Loads Correctly
    [Documentation]    Verifies the one good image on the page actually renders, by asserting
    ...                it is not in the broken set and reports a non-zero natural width.
    [Tags]    regression
    Open Broken Images Page
    ${broken}=    Get Broken Image Sources
    Should Not Contain    ${broken}    img/avatar-blank.jpg
    ${width}=    Evaluate JavaScript    ${None}
    ...    () => document.querySelector('div.example img[src="img/avatar-blank.jpg"]').naturalWidth
    Should Be True    ${width} > 0    The avatar image should have rendered
