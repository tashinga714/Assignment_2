import ballerina/graphql;
import ballerina/io;

type EmployeeResponse record {|
    record {|anydata dt;|} data;
|};

public function main() returns error? {
    graphql:Client graphqlClient = check new ("localhost:2120/Perfomance_management");

    string doc = string `
    mutation addEmployee($id:String!,$Firstname:String!,$Lastname:Lastname!,$Jobtitle:Jobtitle!,$Position:Position!,$role:role!){
        addEmployee(newproduct:{id:$id, firstname:$firstname, Jobtitle:$Jobtitle, Position:$Position, role:$role!})
    }`;

    EmployeeResponse addEmployeeResponse = check graphqlClient->execute(doc, {"id": "1", "Firstname": "Emma", "Lastname": "John", "Jobtitle": "Seceretary","Position":"Receptionist","role":"Assisting Clients","KeyPerfomanceIdentify":"Professinaol Develepment"});

    io:println("Response ", addEmployeeResponse);
}