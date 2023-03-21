## Testing
Terratests currently only do a plan for this module.  No deploly/teardowns are currently run

# Usage
The go libraries are compiled at the root folder of metric-filter-alarm module with below commands:

```
~/../$ go mod init htme
~/../$ go mod tidy
```


To run the tests execute the following:

```
~/../$ go test -v -timeout 30m htme_test.go
```
