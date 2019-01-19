//
// Created by csc on 11/14/18.
//
#include <vector>
#include <algorithm>
#include <cstdio>
#include <iostream>
using namespace std;
class A {
private:
    int a;
public:
    A (int a_) : a (a_) { }
    int get () const { return a; }
    void set (int a_) { a = a_; }
};

// ...........................................................
/*
void g ( const vector<A> & v ) {
    cout << v[0].get();
    v[0].set (1234);
} // ()
*/
// ...........................................................
void h ( const vector<A *> & v ) {
    cout << (*v[0]).get();
    (*v[0]).set(1234);
    cout << (v[0]->get()) << endl;
}
void f ( vector<A *> & v ) {
    A curB = A(1);
    //A* const pb = &curB;
    v[0] = &curB;
    cout << (v[0]->get()) << endl;
}

int main()
{
    const vector<int>a(10);
    //a.push_back(0);
    //a.push_back(1);
    //for (auto it = a.begin() ; it != a.end(); ++it)
    //{
    //    it->set(1);
    //}

    cout << a[0] << " " << a[1] << endl;
    vector<A*>v;
    A curA = A(0);

    A* pa = &curA;
    v.push_back(pa);

    h(v);
    f(v);
    int val = 10;
    int * const p = &val;
    cout << *p << endl;
    *p = 12;
    cout << *p << endl;
    return 0;
}

