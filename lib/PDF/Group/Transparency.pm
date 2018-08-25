use v6;

use PDF::Group;

class PDF::Group::Transparency
    is PDF::Group {
    use PDF::COS::Tie;
    use PDF::COS::Name;
    use PDF::ColorSpace;

    has PDF::COS::Name $.S is entry(:required) where 'Transparency';
    my subset NameOrColorSpace where PDF::COS::Name|PDF::ColorSpace;
    has NameOrColorSpace  $.CS is entry(:alias<color-space>); #| (Sometimes required) The group colour space, which is used for the following purposes:
    #| • As the colour space into which colours shall be converted when painted into the group
    #| • As the blending colour space in which objects shall be composited within the group
    #| • As the colour space of the group as a whole when it in turn is painted as an object onto its backdrop
    has Bool $.I is entry(:alias<isolated>); #| (Optional) A flag specifying whether the transparency group is isolated
    has Bool $.K is entry(:alias<knockout>); #| (Optional) A flag specifying whether the transparency group is a knockout group
}
