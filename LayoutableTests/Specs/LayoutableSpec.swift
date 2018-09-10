//
//  LayoutableSpec.swift
//  LayoutableTests
//
//  Copyright © 2018 kwiecien.co. All rights reserved.
//

@testable import Layoutable
import Quick
import Nimble

internal final class LayoutableSpec: QuickSpec {

    override func spec() {
        context("having superview") {
            let superview = UIView()

            describe("laoutable()") {
                it("disables `translatesAutoresizingMaskIntoConstraints` for the view") {
                    let view = UIView().layoutable()
                    expect(view.translatesAutoresizingMaskIntoConstraints) == false
                }
            }

            describe("`translatesAutoresizingMaskIntoConstraints` assertion") {
                it("crashes the app if view hasn't been prepared") {
                    let view = UIView()
                    superview.addSubview(view)
                    expect { view.constrainToSuperviewEdges() }.to(throwAssertion())
                }

                it("doesn't crash the app if view has been prepared") {
                    let view = UIView().layoutable()
                    superview.addSubview(view)
                    expect { view.constrainToSuperviewEdges() }.toNot(throwAssertion())
                }
            }

            describe("`constrainToSuperviewEdges()` superview assertion") {
                it("crashes the app if view doesn't have superview") {
                    let view = UIView()
                    expect { view.constrainToSuperviewEdges() }.to(throwAssertion())
                }

                it("doesn't crash the app if view has superview") {
                    let view = UIView().layoutable()
                    superview.addSubview(view)
                    expect { view.constrainToSuperviewEdges() }.toNot(throwAssertion())
                }
            }

            describe("`constrainToSuperviewLayoutGuide()` superview assertion") {
                it("crashes the app if view doesn't have superview") {
                    let view = UIView()
                    expect { view.constrainToSuperviewLayoutGuide() }.to(throwAssertion())
                }

                it("doesn't crash the app if view has superview") {
                    let view = UIView().layoutable()
                    superview.addSubview(view)
                    expect { view.constrainToSuperviewLayoutGuide() }.toNot(throwAssertion())
                }
            }

            describe("`constrainCenterToSuperview()` superview assertion") {
                it("crashes the app if view doesn't have superview") {
                    let view = UIView()
                    expect { view.constrainCenterToSuperview() }.to(throwAssertion())
                }

                it("doesn't crash the app if view has superview") {
                    let view = UIView().layoutable()
                    superview.addSubview(view)
                    expect { view.constrainCenterToSuperview() }.toNot(throwAssertion())
                }
            }

            context("and properly prepared and added view to the superview") {
                let view = UIView().layoutable()
                superview.addSubview(view)

                describe("`constrainToSuperviewEdges()`") {
                    describe("without parameters") {
                        it("returns all constraints") {
                            let constraints = view.constrainToSuperviewEdges()
                            expect(constraints.count) == 4

                            let topConstraint = constraints.first(where: { $0.firstAnchor == view.topAnchor })!
                            expect(topConstraint.constant) == 0
                            expect(topConstraint.relation) == .equal
                            expect(topConstraint.secondAnchor) == superview.topAnchor
                            expect(topConstraint.isActive) == true

                            let trailingConstraint = constraints.first(where: { $0.firstAnchor == view.trailingAnchor })!
                            expect(trailingConstraint.constant) == 0
                            expect(trailingConstraint.relation) == .equal
                            expect(trailingConstraint.secondAnchor) == superview.trailingAnchor
                            expect(trailingConstraint.isActive) == true

                            let bottomConstraint = constraints.first(where: { $0.firstAnchor == view.bottomAnchor })!
                            expect(bottomConstraint.constant) == 0
                            expect(bottomConstraint.relation) == .equal
                            expect(bottomConstraint.secondAnchor) == superview.bottomAnchor
                            expect(bottomConstraint.isActive) == true

                            let leadingConstraint = constraints.first(where: { $0.firstAnchor == view.leadingAnchor })!
                            expect(leadingConstraint.constant) == 0
                            expect(leadingConstraint.relation) == .equal
                            expect(leadingConstraint.secondAnchor) == superview.leadingAnchor
                            expect(leadingConstraint.isActive) == true
                        }
                    }

                    describe("excluding all edges") {
                        it("returns empty array of constraints") {
                            let constraints = view.constrainToSuperviewEdges(excluding: [.top, .trailing, .bottom, .leading])
                            expect(constraints.count) == 0
                        }
                    }

                    describe("excluding top and bottom edges") {
                        it("returns array of constraints with leading and trailing constraint") {
                            let constraints = view.constrainToSuperviewEdges(excluding: [.top, .bottom])
                            expect(constraints.count) == 2
                            expect(constraints.first(where: { $0.firstAnchor == view.trailingAnchor })!).toNot(beNil())
                            expect(constraints.first(where: { $0.firstAnchor == view.leadingAnchor })!).toNot(beNil())
                        }
                    }

                    describe("excluding leading and trailing edges") {
                        it("returns array of constraints with top and bottom constraint") {
                            let constraints = view.constrainToSuperviewEdges(excluding: [.leading, .trailing])
                            expect(constraints.count) == 2
                            expect(constraints.first(where: { $0.firstAnchor == view.topAnchor })!).toNot(beNil())
                            expect(constraints.first(where: { $0.firstAnchor == view.bottomAnchor })!).toNot(beNil())
                        }
                    }

                    describe("with various insets") {
                        it("returns array of constraints with properly added insets") {
                            let constraints = view.constrainToSuperviewEdges(insets: .init(top: 1, left: 2, bottom: 3, right: 4))
                            expect(constraints.first(where: { $0.firstAnchor == view.topAnchor })!.constant) == 1
                            expect(constraints.first(where: { $0.firstAnchor == view.trailingAnchor })!.constant) == -4
                            expect(constraints.first(where: { $0.firstAnchor == view.bottomAnchor })!.constant) == -3
                            expect(constraints.first(where: { $0.firstAnchor == view.leadingAnchor })!.constant) == 2
                        }
                    }
                }

                describe("`constrainToSuperviewLayoutGuide()`") {
                    describe("without parameters") {
                        it("returns all constraints") {
                            let constraints = view.constrainToSuperviewLayoutGuide()
                            expect(constraints.count) == 4

                            let topConstraint = constraints.first(where: { $0.firstAnchor == view.topAnchor })!
                            expect(topConstraint.constant) == 0
                            expect(topConstraint.relation) == .equal
                            expect(topConstraint.secondAnchor) == superview.safeAreaLayoutGuide.topAnchor
                            expect(topConstraint.isActive) == true

                            let trailingConstraint = constraints.first(where: { $0.firstAnchor == view.trailingAnchor })!
                            expect(trailingConstraint.constant) == 0
                            expect(trailingConstraint.relation) == .equal
                            expect(trailingConstraint.secondAnchor) == superview.safeAreaLayoutGuide.trailingAnchor
                            expect(trailingConstraint.isActive) == true

                            let bottomConstraint = constraints.first(where: { $0.firstAnchor == view.bottomAnchor })!
                            expect(bottomConstraint.constant) == 0
                            expect(bottomConstraint.relation) == .equal
                            expect(bottomConstraint.secondAnchor) == superview.safeAreaLayoutGuide.bottomAnchor
                            expect(bottomConstraint.isActive) == true

                            let leadingConstraint = constraints.first(where: { $0.firstAnchor == view.leadingAnchor })!
                            expect(leadingConstraint.constant) == 0
                            expect(leadingConstraint.relation) == .equal
                            expect(leadingConstraint.secondAnchor) == superview.safeAreaLayoutGuide.leadingAnchor
                            expect(leadingConstraint.isActive) == true
                        }
                    }

                    describe("excluding all edges") {
                        it("returns empty array of constraints") {
                            let constraints = view.constrainToSuperviewLayoutGuide(excluding: [.top, .trailing, .bottom, .leading])
                            expect(constraints.count) == 0
                        }
                    }

                    describe("excluding top and bottom edges") {
                        it("returns array of constraints with leading and trailing constraint") {
                            let constraints = view.constrainToSuperviewLayoutGuide(excluding: [.top, .bottom])
                            expect(constraints.count) == 2
                            expect(constraints.first(where: { $0.firstAnchor == view.trailingAnchor })!).toNot(beNil())
                            expect(constraints.first(where: { $0.firstAnchor == view.leadingAnchor })!).toNot(beNil())
                        }
                    }

                    describe("excluding leading and trailing edges") {
                        it("returns array of constraints with top and bottom constraint") {
                            let constraints = view.constrainToSuperviewLayoutGuide(excluding: [.leading, .trailing])
                            expect(constraints.count) == 2
                            expect(constraints.first(where: { $0.firstAnchor == view.topAnchor })!).toNot(beNil())
                            expect(constraints.first(where: { $0.firstAnchor == view.bottomAnchor })!).toNot(beNil())
                        }
                    }

                    describe("with various insets") {
                        it("returns array of constraints with properly added insets") {
                            let constraints = view.constrainToSuperviewLayoutGuide(insets: .init(top: 1, left: 2, bottom: 3, right: 4))
                            expect(constraints.first(where: { $0.firstAnchor == view.topAnchor })!.constant) == 1
                            expect(constraints.first(where: { $0.firstAnchor == view.trailingAnchor })!.constant) == -4
                            expect(constraints.first(where: { $0.firstAnchor == view.bottomAnchor })!.constant) == -3
                            expect(constraints.first(where: { $0.firstAnchor == view.leadingAnchor })!.constant) == 2
                        }
                    }
                }

                describe("`constrainCenterToSuperview()`") {
                    describe("without parameters") {
                        it("returns all constraints") {
                            let constraints = view.constrainCenterToSuperview()
                            expect(constraints.count) == 2

                            let xConstraint = constraints.first(where: { $0.firstAnchor == view.centerXAnchor })!
                            expect(xConstraint.constant) == 0
                            expect(xConstraint.relation) == .equal
                            expect(xConstraint.secondAnchor) == superview.centerXAnchor
                            expect(xConstraint.isActive) == true

                            let yConstraint = constraints.first(where: { $0.firstAnchor == view.centerYAnchor })!
                            expect(yConstraint.constant) == 0
                            expect(yConstraint.relation) == .equal
                            expect(yConstraint.secondAnchor) == superview.centerYAnchor
                            expect(yConstraint.isActive) == true
                        }
                    }


                    describe("with various insets") {
                        it("returns array of constraints with properly added insets") {
                            let constraints = view.constrainCenterToSuperview(constant: .init(x: 1, y: 2))
                            expect(constraints.first(where: { $0.firstAnchor == view.centerXAnchor })!.constant) == 1
                            expect(constraints.first(where: { $0.firstAnchor == view.centerYAnchor })!.constant) == 2
                        }
                    }
                }

                describe("`constrainToConstant()`") {
                    describe("without parameters") {
                        it("returns all constraints") {
                            let constraints = view.constrainToConstant(size: .zero)
                            expect(constraints.count) == 2

                            let xConstraint = constraints.first(where: { $0.firstAnchor == view.widthAnchor })!
                            expect(xConstraint.constant) == 0
                            expect(xConstraint.relation) == .equal
                            expect(xConstraint.secondAnchor).to(beNil())
                            expect(xConstraint.isActive) == true

                            let yConstraint = constraints.first(where: { $0.firstAnchor == view.heightAnchor })!
                            expect(yConstraint.constant) == 0
                            expect(yConstraint.relation) == .equal
                            expect(yConstraint.secondAnchor).to(beNil())
                            expect(yConstraint.isActive) == true
                        }
                    }

                    describe("with custom constant") {
                        it("returns array of constraints with properly set constants") {
                            let constraints = view.constrainToConstant(size: .init(width: 1, height: 2))
                            expect(constraints.first(where: { $0.firstAnchor == view.widthAnchor })!.constant) == 1
                            expect(constraints.first(where: { $0.firstAnchor == view.heightAnchor })!.constant) == 2
                        }
                    }
                }
            }
        }
    }
}
