Configuration dscterrpoc {


}

$MyData = 
@{
    AllNodes = 
    @(
        @{
            NodeName = "*"
            Role     = "FileServer"
        },


        @{
            NodeName = "dscterrpocweb"
            Role     = "WebServer"

        },


        @{
            NodeName = "dscterrpocsql"
            Role     = "SQLServer"
        }

    );
}