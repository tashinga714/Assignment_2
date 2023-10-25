import ballerina/graphql;
import ballerina/io;
import ballerinax/mongodb;

type Employee record {
    string employeeId;
    int score;
    int supervisorGrade;
    string Firstname;
    string Lastname;
    string Jobtitle;
    string Position;
    string role;
};

type User record {
    string Employeename;
    string password;
};

type UserDetails record {
    string Employeename;
    string? password;
    boolean isAdmin;
};

type UpdatedUserDetails record {
    string Employeename;
    string password;
};

type LoggedUserDetails record {|
    string Employeename;
    boolean isAdmin;
|};


type HoD record {
    string id;
    string Firstname;
    string Lastname;
    string Jobtitle;
    string Position;
    string role;
};

type HoD_user record {
    string HoDname;
    string password;
};

type HoD_user_Details record {
    string HoDname;
    string? password;
    boolean isAdmin;
};

type HoD_updated_user_details record {
    string HoDname;
    string password;
};

type HoD_logged_user_details record {|
    string HoDname;
    boolean isAdmin;
|};

type Supervisor record {
    string id;
    string Firstname;
    string Lastname;
    string Jobtitle;
    string Position;
    string role;
};

type Supervisor_user record {
    string Supervisorname;
    string password;
};

type Supervisor_user_Details record {
    string Supervisorname;
    string? password;
    boolean isAdmin;
};

type Supervisor_updated_user_details record {
    string Supervisorname;
    string password;
};

type Supervisor_logged_user_details record {|
    string Supervisorname;
    boolean isAdmin;
|};


mongodb:ConnectionConfig mongoConfig = {
    connection: {
        host: "localhost",
        port: 27017,
        auth: {
            username: "",
            password: ""
        },
        options: {
            sslEnabled: false,
            serverSelectionTimeout: 5000
        }
    },
    databaseName: "Performance_Tracking"
};

mongodb:Client db = check new (mongoConfig);
configurable string EmployeeCollection = "Employee";
configurable string userCollection = "Users";
configurable string HoDCollection = "HoD";
configurable string HoD_userCollection = "HoD_users";
configurable string SupervisorCollection = "Supervisor";
configurable string Supervisor_userCollection = "Supervisor_users";
configurable string databaseName = "Performance_Tracking";

@graphql:ServiceConfig {
    graphiql: {
        enabled: true,
    // Path is optional, if not provided, it will be dafulted to /graphiql.
    path: "/Performance_Tracking"
    }
}
service /Employee on new graphql:Listener(2120) {


    // mutation
    remote function deleteDepartment(string id) returns error|string {
        mongodb:Error|int deleteItem = db->delete(HoDCollection, "", {id: id}, false);
        if deleteItem is mongodb:Error {
            return error("Failed to delete items");
        } else {
            if deleteItem > 0 {
                return string `${id} deleted successfully`;
            } else {
                return string `department not found`;
            }
        }

    }

    // query
    resource function get Employee(User user) returns LoggedUserDetails|error {
        stream<UserDetails, error?> usersDetails = check db->find(EmployeeCollection, databaseName, {Employeename: user.Employeename, password: user.password}, {});

        UserDetails[] users = check from var userInfo in usersDetails
            select userInfo;
        io:println("Employee", Employee);
        // If the user is found return a user or return a string user not found
       if users.length() > 0 {
            return {Employeename: users[0].Employeename, isAdmin: users[0].isAdmin};
        }
        return {
            Employeename: "",
            isAdmin: false
        };
    }

    // mutation
    remote function registerEmployee(User newEmployee) returns error|string {

        map<json> doc = <map<json>>{isAdmin: false, Employeename: newEmployee.Employeename, password: newEmployee.password};
        _ = check db->insert(doc, EmployeeCollection, "");
        return string `${newEmployee.Employeename} added successfully`;
    }
}
 
 