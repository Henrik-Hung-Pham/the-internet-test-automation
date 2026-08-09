*** Settings ***
Documentation       Shared TinyMCE Locators
...                 the-internet serves the same TinyMCE widget on both /iframe and /tinymce,
...                 so the editor locators live here and are reused by both feature suites.


*** Variables ***
${TINYMCE_IFRAME}           [id="mce_0_ifr"]
# Browser library pierces into a frame with ``>>>``, so this addresses the editable
# body *inside* the iframe and can be clicked/typed into like any other element.
${TINYMCE_BODY}             ${TINYMCE_IFRAME} >>> body#tinymce
${TINYMCE_NOTIFICATION}     .tox-notification, .mce-notification
