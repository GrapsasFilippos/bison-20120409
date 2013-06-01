#ifndef IDENTIFIER_HPP
#define IDENTIFIER_HPP

#include <string>

#include "gfbinarysearchtreedatacontainer.hpp"

using namespace std;


class Identifier : public GFBinarySearchTreeDataContainer< string * > {
	public:
        Identifier();
        ~Identifier() {}

        int compare( GFBinarySearchTreeDataContainer< string * > * ldata ) {
            return key->compare( *ldata->getKey() );
        }
        void setKey( string * lkey ) {
            key = lkey;
		}
        string * getKey() {
            //cout << "*" << type << "*";
            return key;
		}

        void setType( int ltype ) {
            type = ltype;
        }
        int getType() {
            return( type );
        }

	private:
        string * key;
        int type;

};


#endif
