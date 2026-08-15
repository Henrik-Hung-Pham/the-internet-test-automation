*** Settings ***
Documentation       Broken Images Keywords

Resource            ../common.resource
Resource            ../locators/broken_images_locators.resource
Resource            ../variables/global_variables.resource

Library             Collections


*** Keywords ***
Open Broken Images Page
    [Documentation]    Opens the browser and navigates to the broken images page.
    New Page    ${URL_BROKEN_IMAGES}
    Wait For Load State    load    timeout=30s

Get Broken Image Sources
    [Documentation]    Returns the ``src`` filename of every image that failed to load.
    ...                A complete image with naturalWidth 0 is one the browser could not decode.
    ${sources}=    Evaluate JavaScript    ${None}
    ...    () => Array.from(document.querySelectorAll('div.example img'))
    ...    .filter(img => img.complete && img.naturalWidth === 0)
    ...    .map(img => img.getAttribute('src'))
    RETURN    ${sources}

Get Broken Image Count
    [Documentation]    Returns the number of images that failed to load.
    ${sources}=    Get Broken Image Sources
    ${count}=    Get Length    ${sources}
    RETURN    ${count}

Verify Broken Images Are Exactly
    [Documentation]    Verifies precisely which images are broken, not merely how many.
    [Arguments]    @{expected_sources}
    ${actual}=    Get Broken Image Sources
    Sort List    ${actual}
    ${expected}=    Evaluate    sorted($expected_sources)
    Lists Should Be Equal    ${actual}    ${expected}
    ...    msg=Unexpected set of broken images

Verify Page Has Images
    [Documentation]    Verifies the page renders its three example images.
    ${count}=    Get Element Count    ${ALL_IMAGES}
    Should Be Equal As Integers    ${count}    3
    ...    msg=The broken images example should render three images
