use v6;

use PDF::DAO::Tie::Hash;
use PDF::Graphics::ResourceDict;

role PDF::Doc::Type::Resources
    does PDF::DAO::Tie::Hash
    does PDF::Graphics::ResourceDict {

    use PDF::DAO::Tie;
    use PDF::DAO::Name;
    use PDF::DAO::Stream;

    # See [PDF 1.7 TABLE 3.30 Entries in a resource dictionary]

    has %.ExtGState  is entry;  #| (Optional) A dictionary that maps resource names to graphics state parameter dictionaries

    use PDF::Doc::Type::ColorSpace;
    my subset NameOrColorSpace of PDF::DAO where PDF::DAO::Name | PDF::Doc::Type::ColorSpace;
    has NameOrColorSpace %.ColorSpace is entry;  #| (Optional) A dictionary that maps each resource name to either the name of a device-dependent color space or an array describing a color space

    has %.Pattern    is entry;  #| (Optional) A dictionary that maps resource names to pattern objects

    has %.Shading    is entry;  #| (Optional; PDF 1.3) A dictionary that maps resource names to shading dictionaries

    has PDF::DAO::Stream %.XObject    is entry;  #| (Optional) A dictionary that maps resource names to external objects

    has Hash %.Font       is entry;  #| (Optional) A dictionary that maps resource names to font dictionaries
    has PDF::DAO::Name @.ProcSet    is entry;  #| (Optional) An array of predefined procedure set names
    has Hash %.Properties is entry;  #|  (Optional; PDF 1.2) A dictionary that maps resource names to property list dictionaries for marked content

    method core-font(|c) {
	use PDF::Doc::Type::Font;
	use PDF::Graphics::Font;

        my $font-obj = PDF::Graphics::Font::core-font( |c );
        self!find-resource(sub ($_){.isa(PDF::Doc::Type::Font) && .font-obj === $font-obj}, :type<Font>)
            // do {
                my $dict = $font-obj.to-dict;
                my $font-dict = PDF::DAO.coerce( :$dict, :$font-obj );
                self!register-resource( $font-dict );
        };
    }

}

