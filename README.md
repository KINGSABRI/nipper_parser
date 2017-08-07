# NipperParser
[![travis-cli](https://api.travis-ci.org/KINGSABRI/nipper_parser.svg)](https://travis-ci.org/KINGSABRI/nipper_parser/) 
[![Code Climate](https://codeclimate.com/github/KINGSABRI/nipper_parser/badges/gpa.svg)](https://codeclimate.com/github/KINGSABRI/nipper_parser) 
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/8c81748967664cc5bb92147581fb6802)](https://www.codacy.com/app/king-sabri/attack-domain?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=KINGSABRI/nipper_parser&amp;utm_campaign=Badge_Grade)  
[![inch-ci](https://inch-ci.org/github/KINGSABRI/nipper_parser.svg?branch=master)](https://inch-ci.org/github/KINGSABRI/nipper_parser)
[![Gem Version](https://badge.fury.io/rb/nipper_parser.svg)](https://badge.fury.io/rb/nipper_parser)

NipperParser gem is an unofficial parser for [Titania Nipper Studio](https://www.titania.com/products/nipper-studio) XML report.


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
 

## Installation (not published yet)

```ruby
gem install nipper_parser
```
## Usage

##### Report information
```ruby
nipper_parser = NipperParser::Config.open('network-devices.xml') 
puts nipper_parser.information.title
puts nipper_parser.information.author
puts nipper_parser.information.date
puts nipper_parser.information.devices 
```
##### Dealing with Security Audit 
```ruby
nipper_parser = NipperParser::Config.open('network-devices.xml') 
pp nipper_parser.security_audit
pp nipper_parser.security_audit.findings
finding = security_audit.findings[0]              # Play wit a finding
pp finding
pp finding.index
pp finding.title
pp finding.rating
pp finding.ref
pp finding.affected_devices
pp finding.finding
pp finding.impact
pp finding.recommendation
```

##### Report Summaries 
```ruby
nipper_parser = NipperParser::Config.open('network-devices.xml') 
pp security_audit.introduction
pp security_audit.introduction.title
pp security_audit.introduction.date
pp security_audit.introduction.security_issue_overview

pp security_audit.conclusions
pp security_audit.conclusions.per_device
pp security_audit.conclusions.list_critical

pp security_audit.recommendations.list

pp security_audit.mitigation_classification
pp security_audit.mitigation_classification.list_by.fixing[:involved]
pp security_audit.mitigation_classification.list_by.fixing[:involved][0].rating[:rating]
pp security_audit.mitigation_classification.list_by.rating[:high]
pp security_audit.mitigation_classification.list_by.rating[:high][0].rating[:fix]
pp security_audit.mitigation_classification.statistics
pp security_audit.mitigation_classification.statistics.findings
pp security_audit.mitigation_classification.statistics.report
```


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/nipper_parser.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

