import ballerina/test;

@test:Config {
    groups: ["query"],
    enable: true
}
function testUser() returns error? {
    string query = "query { user { login } }";
    json expectedResult = {
        "data": {
            "user": {
                "login": owner
            }
        }
    };
    json actualResult = check testClient->execute(query);
    test:assertEquals(expectedResult, actualResult, "Invalid user name");
}

@test:Config {
    groups: ["query"],
    enable: true
}
function testRepositories() returns error? {
    string query = "query { repositories { name }}";
    json jsonResponse = check testClient->execute(query);
    test:assertTrue(jsonResponse is map<json>, "Invalid response type");
    map<json> actualResult = check jsonResponse.ensureType();
    test:assertTrue(actualResult.hasKey("data"));
    test:assertFalse(actualResult.hasKey("errors"));
}

@test:Config {
    groups: ["query"],
    enable: true
}
function testRepository() returns error? {
    string repoName = "Module-Ballerina-GraphQL";
    string query = string `query { repository(repositoryName: "${repoName}"){ defaultBranch, description } }`;
    json expectedResult = {
        "data": {
            "repository": {
                "defaultBranch": "master",
                "description": "This is the Ballerina GraphQL module, which is a part of Ballerina Language Standard Library"
            }
        }
    };
    json actualResult = check testClient->execute(query);
    test:assertEquals(actualResult, expectedResult);
}

@test:Config {
    groups: ["query"],
    enable: false
}
function testBranches() returns error? {
    string repoName = "Moduel-Ballerina-GraphQL";
    string query = string `query { branches(repositoryName: "${repoName}"){ name } }`;
    json expectedResult = {
        "data": {
            "branches": [
                {
                    "name": "master"
                }
            ]
        }
    };
    json actualResult = check testClient->execute(query);
    test:assertEquals(expectedResult, actualResult);
}

@test:Config {
    groups: ["mutation"],
    enable: true
}
function createRepository() returns error? {
    string repoName = "Test-Repo";
    string query = string `mutation {createRepository(createRepoInput: {name: "${repoName}"}) {name} }`;
    json expectedResult = {
        "errors":[
            {
                "message":"Unprocessable Entity",
                "locations":[
                    {
                        "line":1,
                        "column":11
                    }
                ],
            "path":["createRepository"]
            }
        ],
        "data":null
    };
    json actualResult = check testClient->execute(query);
    test:assertEquals(expectedResult, actualResult);
}
