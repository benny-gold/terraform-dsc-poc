# if you edit this file, make sure to run "terraform taint azurerm_storage_blob.dsc_config" to ensure it is re-uploaded

Configuration dscterrpoc {
    param(
        [string]    
        $nodeName = "localhost"
    )

    $password = "Password1" | convertto-securestring -asPlainText -Force

    Node $AllNodes.Where{$_.Role -eq "Server"}.NodeName {
        User benny {
            Ensure   = "Present"
            UserName = "benny"
            Password = $password
        }
    }
    Node $AllNodes.Where{$_.Role -eq "WebServer"}.NodeName {
        file wwwroot {
            DestinationPath = "C:\web"
            Ensure          = "Present"
            Type            = "Directory"
        } 
        file webconfig {
            DestinationPath = "C:\web\web.config"
            Ensure          = "Present"
            Contents        = "I am a web server"
        }
        
    }
    Node $AllNodes.Where{$_.Role -eq "APIServer"}.NodeName {
        file wwwroot {
            DestinationPath = "C:\web"
            Ensure          = "Present"
            Type            = "Directory"
        } 
        file webconfig {
            DestinationPath = "C:\web\web.config"
            Ensure          = "Present"
            Contents        = "I am an API server"
        }
    }
    Node $AllNodes.Where{$_.Role -eq "SQLServer"}.NodeName {
        file sql {
            DestinationPath = "C:\sql"
            Ensure          = "Present"
            Type            = "Directory"
        } 
        file webconfig {
            DestinationPath = "C:\web\sql.txt"
            Ensure          = "Present"
            Contents        = "I am a sql server"
        }
    }
}

$MyData = 
@{
    AllNodes = 
    @(
        @{
            NodeName = "*"
            Role     = "Server"
        },


        @{
            NodeName = "${web_vm_name}"
            Role     = "WebServer"

        },      
        
        @{
            NodeName = "${api_vm_name}"
            Role     = "APIServer"

        },


        @{
            NodeName = "${sql_vm_name}"
            Role     = "SQLServer"
        }

    );
}