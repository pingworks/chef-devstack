# devstack-cookbook

Multinode devstack installation

## Supported Platforms

TODO: List your supported platforms.

## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['devstack']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

## Usage

### devstack::default

Include `devstack` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[devstack::default]"
  ]
}
```

## License and Authors

Author:: Christoph Lukas (<christoph.lukas@gmx.net>)
