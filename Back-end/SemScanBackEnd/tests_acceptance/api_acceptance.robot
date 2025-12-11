*** Settings ***
Library           RequestsLibrary
Suite Setup       Create Session    backend    http://127.0.0.1:8000    disable_warnings=true
Suite Teardown    Delete All Sessions

*** Test Cases ***
User Can Be Created And Retrieved
    ${resp}=    Post Request    backend    /users/    json={"username":"acc_user","email":"acc@example.com"}
    Should Be Equal As Integers    ${resp.status_code}    201
    ${user_id}=    Set Variable    ${resp.json()["id"]}
    ${get}=    Get Request    backend    /users/${user_id}/
    Should Be Equal As Integers    ${get.status_code}    200
    Should Be Equal    ${get.json()["username"]}    acc_user

Comments On Invalid Novel Should Fail
    ${user}=    Post Request    backend    /users/    json={"username":"acc2","email":"acc2@example.com"}
    ${resp}=    Post Request    backend    /comments/    json={"content":"ok","novel":999999,"user":${user.json()["id"]}}
    Should Be Equal As Integers    ${resp.status_code}    404

Performance Basic Response Time
    ${start}=    Get Time    epoch
    ${resp}=    Get Request    backend    /novels/
    Should Be True    ${resp.status_code} == 200
    ${end}=    Get Time    epoch
    ${elapsed}=    Evaluate    ${end} - ${start}
    Should Be True    ${elapsed} < 1.0
