function Greet {
    param(
        [parameter(
            Mandatory = $True,
            HelpMessage="Enter you're friends first name."
        )]
        [alias('name')]
        [string]$Firstname,
        [String]$LastName)

        "Hello $Firstname $Lastname"
        
}