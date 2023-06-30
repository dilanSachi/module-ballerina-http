// Copyright (c) 2022 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied. See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/http;
import ballerina/test;
import ballerina/io;

http:Service myservice = service object {
    resource function get hello() returns string {
        return "Hello, World!";
    }
};

@test:Config{}
public function testmy() returns error? {
    http:Listener ll = check new http:Listener(9090, requestLimits = {maxHeaderSize: 100});
    check ll.attach(myservice);
    check ll.'start();

    http:Client cc = check new("http://localhost:9090/hello");
    foreach int i in 0...2000 {
        http:Response resp = check cc->get("/", headers = { "X-Ballerina" : "ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccnnncccccccccccccccccccccccccccccccccccnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn"});
        if resp.statusCode != 431 {
            io:println("Unexpected response status code: " + resp.statusCode.toString());
            test:assertFail("Found another issue");
        } else {
            io:println("Response status code: " + resp.statusCode.toString());
        }
    }
    test:assertFail("Failing intentionally");
}
