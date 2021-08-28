# テーブル設計

## User
| type | column | option |
| - | - | - |
| string | nickname | null: false |
| string | email | null: false |
| string | password | null: false |
| string | icon |  |

### relation
- has_many room, through: userroom
- has_many userroom

## room
| type | column | option |
| - | - | - |
| string | name | null: false |
| boolean | private | default: false |
| string | leader | null: false |
| string | image | null: false |

### relation
- has_many user, through: userroom
- has_many userroom

## UserRoom
| type | column | option |
| - | - | - |
| relation | user | foreign:true |
| relation | room | foreign:true |

### relation
- belongs_to user
- belongs_to room

