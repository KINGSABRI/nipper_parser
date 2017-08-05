# NipperParser

NipperPrser gem is an unofficial parser for [Titania Nipper Studio](https://www.titania.com/products/nipper-studio) XML report.


#### Nipper Modules/Sections

| Modules / Sections     | Supported |
|------------------------|-----------|
| Information            |     x     |
| Security Audit         |     x     |
| Vulnerability Audit    |     x     |
| CIS Benchmarks         |           |
| STIG Compliance        |           |
| SANS Policy Compliance |           |
| PCI Audit              |           |
| Filtering Complexity   |           |
| Configuration Report   |           |
| Raw Configuration      |           |
| Raw Change Tracking    |           |
| Appendix               |           |
 

## Installation

```ruby
gem install nipper_parser
```
## Usage

basic report information 
```ruby
nipper_parser = NipperParser::Config.open('network-devices.xml') 
puts nipper_parser.information.title
puts nipper_parser.information.author
puts nipper_parser.information.date
puts nipper_parser.information.devices

pp nipper_parser.security_audit
pp nipper_parser.security_audit.findings
pp nipper_parser.security_audit.findings[0]
pp nipper_parser.security_audit.findings[0].title
pp nipper_parser.security_audit.findings[0].impact
pp nipper_parser.security_audit.conclusions
pp nipper_parser.security_audit.recommendations.list
pp nipper_parser.security_audit.mitigation_classification
 
```


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/nipper_parser.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

