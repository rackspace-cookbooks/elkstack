# elkstack

Template for new stacks that includes best practices and default files for
Rubocop, Foodcritic (including custom [Rackspace rules](https://github.com/AutomationSupport/foodcritic-rackspace-rules)),
Rake, Thor, etc. Eventually, and ideally, this would be used by [stackbuilder](https://github.com/rackerlabs/stackbuilder)
to initialize new stacks.

## [Changelog](CHANGELOG.md)

See CHANGELOG.md for additional information about changes to this stack over time.

## Supported Platforms

Ubuntu 12.04

CentOS 6.5

## Attributes

Please describe any attributes exposed by this stack, and what the default values are. There shouldn't be any attributes without a default value (e.g. no required attributes, sensible defaults).

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['elkstack']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

## Usage

### elkstack::default

This is where you should define what the default recipe does, if anything.

### elkstack::bacon

Please define what the other recipes do as well.

## Contributing

See [CONTRIBUTING](https://github.com/AutomationSupport/elkstack/blob/master/CONTRIBUTING.md).

## Authors

Author:: Rackspace (devops-chef@rackspace.com)

## License
```
# Copyright 2014, Rackspace Hosting
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
```
