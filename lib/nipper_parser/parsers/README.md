# Nipper Parsers 
This part contains all Nipper Studio Plugins/Sections that might be selected during the configuration audit. 
Each parser is divided in a separate class and file.

### General Report Information

**General Report Information Contains:**
- Introduction                  [implemented]
- Report Conventions            [not yet implemented - PR is welcome]
- Network Filtering Actions     [not yet implemented - PR is welcome]
- Object Filter Types           [not yet implemented - PR is welcome]

#### Usage

```ruby
require 'nipper_parser'
nipper_parser = NipperParser::Config.open('network-devices.xml') 

# - Introduction
puts nipper_parser.information.title
puts nipper_parser.information.author
puts nipper_parser.information.date
puts nipper_parser.information.devices 

# - Report Conventions
# - Network Filtering Actions
# - Object Filter Types
```

### Security Audit
Perform a "best practice" security audit that combines checks from many different sources including penetration testing
experience. 

**Security Audit Section Contains:**
- Introduction                  [implemented]
- Findings                      [implemented]
- Conclusions                   [implemented]
- Recommendations               [implemented]
- Mitigation Classification     [implemented]

#### Usage

```ruby
# - Introduction
pp security_audit.introduction.class
pp security_audit.introduction.title
pp security_audit.introduction.date
pp security_audit.introduction.security_issue_overview

# - Findings
pp security_audit = nipper_parser.security_audit
pp security_audit.findings
finding = security_audit.findings[0]              # Play wit a finding
pp finding.class
pp finding.index
pp finding.title
pp finding.rating
pp finding.ref
pp finding.affected_devices
pp finding.finding
pp finding.impact
pp finding.recommendation

# - Conclusions
pp security_audit.conclusions.class
pp security_audit.conclusions.per_device
pp security_audit.conclusions.list_critical

# - Recommendations
pp security_audit.recommendations.list

# - Mitigation Classification
pp security_audit.mitigation_classification.class
pp security_audit.mitigation_classification.list_by.fixing[:involved]
pp security_audit.mitigation_classification.list_by.fixing[:involved][0].rating[:rating]
pp security_audit.mitigation_classification.list_by.rating[:high]
pp security_audit.mitigation_classification.list_by.rating[:high][0].rating[:fix]
pp security_audit.mitigation_classification.statistics.class
pp security_audit.mitigation_classification.statistics.findings
pp security_audit.mitigation_classification.statistics.report
```

### Vulnerability Audit
A report detailing publically known software vulnerabilities in the device firmware/software versions, including to
manufacturer and third-party references.

**Vulnerability Audit Section Contains:**
- Introduction                  [not yet implemented - PR is welcome]
- CVEs list                     [not yet implemented - PR is welcome]
- Conclusions                   [not yet implemented - PR is welcome]
- Recommendations               [not yet implemented - PR is welcome]

#### Usage

```ruby
# - Introduction
# - CVEs
# - Conclusions
# - Recommendations
```

### CIS Benchmarks
A CIS Benchmarks audit using select profile. Note, support is currently limited to specific devices, any included in the
report that are not supported will be ignored.

**CIS Benchmarks Section Contains:**
- Introduction                  [not yet implemented - PR is welcome]
- Conclusions                   [not yet implemented - PR is welcome]

#### Usage

```ruby
# - Introduction
# - Conclusions
```

### STIG Compliance
A DISA STIG compliance audit against specific STIG checklist.

**STIG Compliance Section Contains:**
- Introduction                  [not yet implemented - PR is welcome]
- Compliance Observations list  [not yet implemented - PR is welcome]
- Conclusions                   [not yet implemented - PR is welcome]
- Recommendations               [not yet implemented - PR is welcome]

#### Usage

```ruby
# - Introduction
# - Observations
# - Conclusions
# - Recommendations
```

### SANS Policy Compliance
A SANS policy compliance audit against specific SANS policy document.

**SANS Policy Compliance Section Contains:**
- Introduction                  [not yet implemented - PR is welcome]
- Compliance Observations list  [not yet implemented - PR is welcome]

#### Usage

```ruby
# - Introduction
# - Observations
# - Conclusions
# - Recommendations
```

### PCI Audit
An audit of Requirement and Security Assessment Procedures against PCI DSS 3.2.

**PCI Audit Section Contains:**
- Introduction                  [not yet implemented - PR is welcome]
- Compliance Requirements list  [not yet implemented - PR is welcome]

#### Usage

```ruby
# - Introduction
# - Requirements
```

### Filtering Complexity 
A report examining the network filtering rules and objects, highlighting unused objects, overlapping or contradictory rules, 
group recursion and more.

**Filtering Complexity Section Contains:**
- Introduction                  [not yet implemented - PR is welcome]
- Observations                  [not yet implemented - PR is welcome]

#### Usage

```ruby
# - Introduction
# - Observations
```

### Configuration Report
A detailed report on how the device has been configured.

**Configuration Report Section Contains:**
- Introduction                  [not yet implemented - PR is welcome]
- Devices Config Audit          [not yet implemented - PR is welcome]

#### Usage

```ruby
# - Introduction
# - Configuration
```

### Raw Configuration 
The raw configuration reporting details the actual device configuration data(excluding directory-based configurations).

**Raw Configuration  Section Contains:**
- Introduction                  [not yet implemented - PR is welcome]
- Devices configuration raw     [not yet implemented - PR is welcome]

#### Usage

```ruby
# - Introduction
# - configuration
```

### Raw Change Tracking
The raw change tracking reporting will detail all the configuration lies that have changes since the previous report.

**Raw Change Tracking Section Contains:**
- Introduction                  [not yet implemented - PR is welcome]

#### Usage

```ruby
# - Introduction
```

### Appendix 
Appendix report section which can include a list of abbreviations, references and other information related to the report contents.

**Appendix Section Contains:**
- Introduction                  [not yet implemented - PR is welcome]
- Logging Severity Levels       [not yet implemented - PR is welcome]
- Common Time Zones             [not yet implemented - PR is welcome]
- IP Protocols                  [not yet implemented - PR is welcome]
- ICMP Types                    [not yet implemented - PR is welcome]
- Abbreviations                 [not yet implemented - PR is welcome]
- Nipper Studio Version         [not yet implemented - PR is welcome]
 

#### Usage

```ruby
# - Introduction
# - Requirements
```

