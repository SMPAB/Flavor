//
//  GridView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-14.
//

import SwiftUI
import Kingfisher

struct GridView: View {
    
    @EnvironmentObject var homeVM: HomeViewModel
    @Binding var posts: [Post]
    let variableTitle: String
    let variableSubtitle: String?
    let navigateFromMain: Bool
    
    var body: some View {
        
        let width = UIScreen.main.bounds.width
        let spacing = width * 12/390
        
        let fullGridCount = posts.count/14
        let leftOverCount = posts.count % 14
        
        
            LazyVStack(alignment: .leading, spacing: spacing){
                
                //MARK: GRID INDEXES
                
                if posts.count > 14 {
                    
                    
                    ForEach(0..<fullGridCount, id: \.self){ gridIndex in
                        let gridIndexInt = gridIndex+1
                        
                        LazyVStack(alignment: .leading, spacing: spacing){
                            HStack(alignment: .top){
                                
                                gridImage(index: gridIndexInt*14-14, widthMultiplier: 235/390, heightMultiplier: 235/390)
                                Spacer()
                                VStack{
                                    gridImage(index: gridIndexInt*14-13, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                    Spacer()
                                    gridImage(index: gridIndexInt*14-12, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                }.frame(height: width * 235/390)
                                
                            }
                            
                            HStack(alignment: .top, spacing: spacing){
                                gridImage(index: gridIndexInt*14-11, widthMultiplier: 112/390, heightMultiplier: 235/390)
                                
                                VStack(spacing: spacing){
                                    HStack(spacing: spacing){
                                        gridImage(index: gridIndexInt*14-10, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                        
                                        gridImage(index: gridIndexInt*14-9, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                    }
                                    
                                    gridImage(index: gridIndexInt*14-8, widthMultiplier: 235/390, heightMultiplier: 112/390)
                                }
                               
                            }
                            
                            HStack{
                                VStack(spacing: spacing){
                                    gridImage(index: gridIndexInt*14-7, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                    
                                    gridImage(index: gridIndexInt*14-6, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                }
                                
                                Spacer()
                                gridImage(index: gridIndexInt*14-5, widthMultiplier: 233/390, heightMultiplier: 235/390)
                            }
                            
                            HStack (spacing: spacing){
                                VStack (spacing: spacing){
                                    HStack(spacing: spacing){
                                        gridImage(index: gridIndexInt*14-4, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                        
                                        gridImage(index: gridIndexInt*14-3, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                        
                                        
                                    }
                                    
                                    gridImage(index: gridIndexInt*14-2, widthMultiplier: 235/390, heightMultiplier: 112/390)
                                }
                                
                                gridImage(index: gridIndexInt*14-1, widthMultiplier: 112/390, heightMultiplier: 235/390)
                            }
                            
                            
                           
                        }
                        //Text("\(gridIndexInt*14 - 0)")
                    }
                    
                    if leftOverCount > 0 {
                        if leftOverCount == 1 {
                            gridImage(index: posts.count-1, widthMultiplier: 235/390, heightMultiplier: 235/390)
                        } else if leftOverCount == 2 {
                            HStack(alignment: .top){
                                
                                gridImage(index: posts.count-2, widthMultiplier: 235/390, heightMultiplier: 235/390)
                                Spacer()
                                gridImage(index: posts.count-1, widthMultiplier: 112/390, heightMultiplier: 112/390)
                            }
                        } else if leftOverCount == 3 {
                            HStack(alignment: .top){
                                
                                gridImage(index: posts.count-3, widthMultiplier: 235/390, heightMultiplier: 235/390)
                                Spacer()
                                VStack{
                                    gridImage(index: posts.count-2, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                    Spacer()
                                    gridImage(index: posts.count-1, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                }.frame(height: width * 235/390)
                                
                            }
                        } else if leftOverCount == 4 {
                            VStack(alignment: .leading, spacing: spacing){
                                HStack(alignment: .top){
                                    
                                    gridImage(index: posts.count-4, widthMultiplier: 235/390, heightMultiplier: 235/390)
                                    Spacer()
                                    VStack{
                                        gridImage(index: posts.count-3, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                        Spacer()
                                        gridImage(index: posts.count-2, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                    }.frame(height: width * 235/390)
                                    
                                }
                                
                                gridImage(index: posts.count-1, widthMultiplier: 112/390, heightMultiplier: 113/390)
                                
                                
                                
                            }
                        } else if leftOverCount == 5 {
                            VStack(alignment: .leading, spacing: spacing){
                                HStack(alignment: .top){
                                    
                                    gridImage(index: posts.count-5, widthMultiplier: 235/390, heightMultiplier: 235/390)
                                    Spacer()
                                    VStack{
                                        gridImage(index: posts.count-4, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                        Spacer()
                                        gridImage(index: posts.count-3, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                    }.frame(height: width * 235/390)
                                    
                                }
                                
                                HStack(spacing: spacing){
                                    gridImage(index: posts.count-2, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                    
                                    gridImage(index: posts.count-1, widthMultiplier: 235/390, heightMultiplier: 113/390)
                                }
                                
                               
                            }
                        } else if leftOverCount == 6 {
                            VStack(alignment: .leading, spacing: spacing){
                                HStack(alignment: .top){
                                    
                                    gridImage(index: posts.count-6, widthMultiplier: 235/390, heightMultiplier: 235/390)
                                    Spacer()
                                    VStack{
                                        gridImage(index: posts.count-5, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                        Spacer()
                                        gridImage(index: posts.count-4, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                    }.frame(height: width * 235/390)
                                    
                                }
                                
                                HStack(alignment: .top, spacing: spacing){
                                    gridImage(index: posts.count-3, widthMultiplier: 112/390, heightMultiplier: 235/390)
                                    
                                    gridImage(index: posts.count-2, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                    
                                    gridImage(index: posts.count-1, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                }
                                
                               
                            }
                        } else if leftOverCount == 7 {
                            VStack(alignment: .leading, spacing: spacing){
                                HStack(alignment: .top){
                                    
                                    gridImage(index: posts.count-7, widthMultiplier: 235/390, heightMultiplier: 235/390)
                                    Spacer()
                                    VStack{
                                        gridImage(index: posts.count-6, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                        Spacer()
                                        gridImage(index: posts.count-5, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                    }.frame(height: width * 235/390)
                                    
                                }
                                
                                HStack(alignment: .top, spacing: spacing){
                                    gridImage(index: posts.count-4, widthMultiplier: 112/390, heightMultiplier: 235/390)
                                    
                                    VStack(spacing: spacing){
                                        HStack(spacing: spacing){
                                            gridImage(index: posts.count-3, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                            
                                            gridImage(index: posts.count-2, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                        }
                                        
                                        gridImage(index: posts.count-1, widthMultiplier: 235/390, heightMultiplier: 112/390)
                                    }
                                   
                                }
                                
                               
                            }
                        } else if leftOverCount == 8 {
                            VStack(alignment: .leading, spacing: spacing){
                                HStack(alignment: .top){
                                    
                                    gridImage(index: posts.count-8, widthMultiplier: 235/390, heightMultiplier: 235/390)
                                    Spacer()
                                    VStack{
                                        gridImage(index: posts.count-7, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                        Spacer()
                                        gridImage(index: posts.count-6, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                    }.frame(height: width * 235/390)
                                    
                                }
                                
                                HStack(alignment: .top, spacing: spacing){
                                    gridImage(index: posts.count-5, widthMultiplier: 112/390, heightMultiplier: 235/390)
                                    
                                    VStack(spacing: spacing){
                                        HStack(spacing: spacing){
                                            gridImage(index: posts.count-4, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                            
                                            gridImage(index: posts.count-3, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                        }
                                        
                                        gridImage(index: posts.count-2, widthMultiplier: 235/390, heightMultiplier: 112/390)
                                    }
                                   
                                }
                                
                                gridImage(index: posts.count-1, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                
                               
                            }
                        } else if leftOverCount == 9 {
                            VStack(alignment: .leading, spacing: spacing){
                                HStack(alignment: .top){
                                    
                                    gridImage(index: posts.count-9, widthMultiplier: 235/390, heightMultiplier: 235/390)
                                    Spacer()
                                    VStack{
                                        gridImage(index: posts.count-8, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                        Spacer()
                                        gridImage(index: posts.count-7, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                    }.frame(height: width * 235/390)
                                    
                                }
                                
                                HStack(alignment: .top, spacing: spacing){
                                    gridImage(index: posts.count-6, widthMultiplier: 112/390, heightMultiplier: 235/390)
                                    
                                    VStack(spacing: spacing){
                                        HStack(spacing: spacing){
                                            gridImage(index: posts.count-5, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                            
                                            gridImage(index: posts.count-4, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                        }
                                        
                                        gridImage(index: posts.count-3, widthMultiplier: 235/390, heightMultiplier: 112/390)
                                    }
                                   
                                }
                                
                                HStack(spacing: spacing){
                                    gridImage(index: posts.count-2, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                    
                                    gridImage(index: posts.count-1, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                }
                                
                                
                               
                            }
                        } else if leftOverCount == 10 {
                            VStack(alignment: .leading, spacing: spacing){
                                HStack(alignment: .top){
                                    
                                    gridImage(index: posts.count-10, widthMultiplier: 235/390, heightMultiplier: 235/390)
                                    Spacer()
                                    VStack{
                                        gridImage(index: posts.count-9, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                        Spacer()
                                        gridImage(index: posts.count-8, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                    }.frame(height: width * 235/390)
                                    
                                }
                                
                                HStack(alignment: .top, spacing: spacing){
                                    gridImage(index: posts.count-7, widthMultiplier: 112/390, heightMultiplier: 235/390)
                                    
                                    VStack(spacing: spacing){
                                        HStack(spacing: spacing){
                                            gridImage(index: posts.count-6, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                            
                                            gridImage(index: posts.count-5, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                        }
                                        
                                        gridImage(index: posts.count-4, widthMultiplier: 235/390, heightMultiplier: 112/390)
                                    }
                                   
                                }
                                
                                HStack{
                                    VStack(spacing: spacing){
                                        gridImage(index: posts.count-3, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                        
                                        gridImage(index: posts.count-2, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                    }
                                    
                                    Spacer()
                                    gridImage(index: posts.count-1, widthMultiplier: 233/390, heightMultiplier: 235/390)
                                }
                                
                                
                                
                               
                            }
                        } else if leftOverCount == 11 {
                            VStack(alignment: .leading, spacing: spacing){
                                HStack(alignment: .top){
                                    
                                    gridImage(index: posts.count-11, widthMultiplier: 235/390, heightMultiplier: 235/390)
                                    Spacer()
                                    VStack{
                                        gridImage(index: posts.count-10, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                        Spacer()
                                        gridImage(index: posts.count-9, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                    }.frame(height: width * 235/390)
                                    
                                }
                                
                                HStack(alignment: .top, spacing: spacing){
                                    gridImage(index: posts.count-8, widthMultiplier: 112/390, heightMultiplier: 235/390)
                                    
                                    VStack(spacing: spacing){
                                        HStack(spacing: spacing){
                                            gridImage(index: posts.count-7, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                            
                                            gridImage(index: posts.count-6, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                        }
                                        
                                        gridImage(index: posts.count-5, widthMultiplier: 235/390, heightMultiplier: 112/390)
                                    }
                                   
                                }
                                
                                HStack{
                                    VStack(spacing: spacing){
                                        gridImage(index: posts.count-4, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                        
                                        gridImage(index: posts.count-3, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                    }
                                    
                                    Spacer()
                                    gridImage(index: posts.count-2, widthMultiplier: 233/390, heightMultiplier: 235/390)
                                }
                                
                                gridImage(index: posts.count-1, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                
                               
                            }
                        } else if leftOverCount == 12 {
                            VStack(alignment: .leading, spacing: spacing){
                                HStack(alignment: .top){
                                    
                                    gridImage(index: posts.count-12, widthMultiplier: 235/390, heightMultiplier: 235/390)
                                    Spacer()
                                    VStack{
                                        gridImage(index: posts.count-11, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                        Spacer()
                                        gridImage(index: posts.count-10, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                    }.frame(height: width * 235/390)
                                    
                                }
                                
                                HStack(alignment: .top, spacing: spacing){
                                    gridImage(index: posts.count-9, widthMultiplier: 112/390, heightMultiplier: 235/390)
                                    
                                    VStack(spacing: spacing){
                                        HStack(spacing: spacing){
                                            gridImage(index: posts.count-8, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                            
                                            gridImage(index: posts.count-7, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                        }
                                        
                                        gridImage(index: posts.count-6, widthMultiplier: 235/390, heightMultiplier: 112/390)
                                    }
                                   
                                }
                                
                                HStack{
                                    VStack(spacing: spacing){
                                        gridImage(index: posts.count-5, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                        
                                        gridImage(index: posts.count-4, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                    }
                                    
                                    Spacer()
                                    gridImage(index: posts.count-3, widthMultiplier: 233/390, heightMultiplier: 235/390)
                                }
                                
                                HStack(spacing: spacing){
                                    gridImage(index: posts.count-2, widthMultiplier: 232/390, heightMultiplier: 112/390)
                                    
                                    gridImage(index: posts.count-1, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                }
                                
                                
                               
                            }
                        } else if leftOverCount == 13 {
                            VStack(alignment: .leading, spacing: spacing){
                                HStack(alignment: .top){
                                    
                                    gridImage(index: posts.count-13, widthMultiplier: 235/390, heightMultiplier: 235/390)
                                    Spacer()
                                    VStack{
                                        gridImage(index: posts.count-12, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                        Spacer()
                                        gridImage(index: posts.count-11, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                    }.frame(height: width * 235/390)
                                    
                                }
                                
                                HStack(alignment: .top, spacing: spacing){
                                    gridImage(index: posts.count-10, widthMultiplier: 112/390, heightMultiplier: 235/390)
                                    
                                    VStack(spacing: spacing){
                                        HStack(spacing: spacing){
                                            gridImage(index: posts.count-9, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                            
                                            gridImage(index: posts.count-8, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                        }
                                        
                                        gridImage(index: posts.count-7, widthMultiplier: 235/390, heightMultiplier: 112/390)
                                    }
                                   
                                }
                                
                                HStack{
                                    VStack(spacing: spacing){
                                        gridImage(index: posts.count-6, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                        
                                        gridImage(index: posts.count-5, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                    }
                                    
                                    Spacer()
                                    gridImage(index: posts.count-4, widthMultiplier: 233/390, heightMultiplier: 235/390)
                                }
                                
                                HStack(spacing: spacing){
                                    gridImage(index: posts.count-3, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                    
                                    gridImage(index: posts.count-2, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                    
                                    gridImage(index: posts.count-1, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                }
                                
                                
                               
                            }
                        }
                    }
                }
                
                
                //MARK: TEST; THE GRID
                    if posts.count == 1 {
                        gridImage(index: 0, widthMultiplier: 255/390, heightMultiplier: 255/390)
                    } else if posts.count == 2 {
                        HStack(alignment: .top){
                            
                            gridImage(index: 0, widthMultiplier: 235/390, heightMultiplier: 235/390)
                            Spacer()
                            gridImage(index: 1, widthMultiplier: 112/390, heightMultiplier: 112/390)
                        }
                    } else if posts.count == 3 {
                        HStack(alignment: .top){
                            
                            gridImage(index: 0, widthMultiplier: 235/390, heightMultiplier: 235/390)
                            Spacer()
                            VStack{
                                gridImage(index: 1, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                Spacer()
                                gridImage(index: 2, widthMultiplier: 112/390, heightMultiplier: 112/390)
                            }.frame(height: width * 235/390)
                            
                        }
                    } else if posts.count == 4 {
                        VStack(alignment: .leading, spacing: spacing){
                            HStack(alignment: .top){
                                
                                gridImage(index: 0, widthMultiplier: 235/390, heightMultiplier: 235/390)
                                Spacer()
                                VStack{
                                    gridImage(index: 1, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                    Spacer()
                                    gridImage(index: 2, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                }.frame(height: width * 235/390)
                                
                            }
                            
                            gridImage(index: 3, widthMultiplier: 112/390, heightMultiplier: 113/390)
                            
                            
                            
                        }
                    } else if posts.count == 5 {
                        VStack(alignment: .leading, spacing: spacing){
                            HStack(alignment: .top){
                                
                                gridImage(index: 0, widthMultiplier: 235/390, heightMultiplier: 235/390)
                                Spacer()
                                VStack{
                                    gridImage(index: 1, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                    Spacer()
                                    gridImage(index: 2, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                }.frame(height: width * 235/390)
                                
                            }
                            
                            HStack(spacing: spacing){
                                gridImage(index: 3, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                
                                gridImage(index: 4, widthMultiplier: 235/390, heightMultiplier: 113/390)
                            }
                            
                           
                        }
                    } else if posts.count == 6 {
                        VStack(alignment: .leading, spacing: spacing){
                            HStack(alignment: .top){
                                
                                gridImage(index: 0, widthMultiplier: 235/390, heightMultiplier: 235/390)
                                Spacer()
                                VStack{
                                    gridImage(index: 1, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                    Spacer()
                                    gridImage(index: 2, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                }.frame(height: width * 235/390)
                                
                            }
                            
                            HStack(alignment: .top, spacing: spacing){
                                gridImage(index: 3, widthMultiplier: 112/390, heightMultiplier: 235/390)
                                
                                gridImage(index: 4, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                
                                gridImage(index: 5, widthMultiplier: 112/390, heightMultiplier: 112/390)
                            }
                            
                           
                        }
                    } else if posts.count == 7 {
                        VStack(alignment: .leading, spacing: spacing){
                            HStack(alignment: .top){
                                
                                gridImage(index: 0, widthMultiplier: 235/390, heightMultiplier: 235/390)
                                Spacer()
                                VStack{
                                    gridImage(index: 1, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                    Spacer()
                                    gridImage(index: 2, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                }.frame(height: width * 235/390)
                                
                            }
                            
                            HStack(alignment: .top, spacing: spacing){
                                gridImage(index: 3, widthMultiplier: 112/390, heightMultiplier: 235/390)
                                
                                VStack(spacing: spacing){
                                    HStack(spacing: spacing){
                                        gridImage(index: 4, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                        
                                        gridImage(index: 5, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                    }
                                    
                                    gridImage(index: 6, widthMultiplier: 235/390, heightMultiplier: 112/390)
                                }
                               
                            }
                            
                           
                        }
                    } else if posts.count == 8 {
                        VStack(alignment: .leading, spacing: spacing){
                            HStack(alignment: .top){
                                
                                gridImage(index: 0, widthMultiplier: 235/390, heightMultiplier: 235/390)
                                Spacer()
                                VStack{
                                    gridImage(index: 1, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                    Spacer()
                                    gridImage(index: 2, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                }.frame(height: width * 235/390)
                                
                            }
                            
                            HStack(alignment: .top, spacing: spacing){
                                gridImage(index: 3, widthMultiplier: 112/390, heightMultiplier: 235/390)
                                
                                VStack(spacing: spacing){
                                    HStack(spacing: spacing){
                                        gridImage(index: 4, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                        
                                        gridImage(index: 5, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                    }
                                    
                                    gridImage(index: 6, widthMultiplier: 235/390, heightMultiplier: 112/390)
                                }
                               
                            }
                            
                            gridImage(index: 7, widthMultiplier: 112/390, heightMultiplier: 112/390)
                            
                           
                        }
                    } else if posts.count == 9 {
                        VStack(alignment: .leading, spacing: spacing){
                            HStack(alignment: .top){
                                
                                gridImage(index: 0, widthMultiplier: 235/390, heightMultiplier: 235/390)
                                Spacer()
                                VStack{
                                    gridImage(index: 1, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                    Spacer()
                                    gridImage(index: 2, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                }.frame(height: width * 235/390)
                                
                            }
                            
                            HStack(alignment: .top, spacing: spacing){
                                gridImage(index: 3, widthMultiplier: 112/390, heightMultiplier: 235/390)
                                
                                VStack(spacing: spacing){
                                    HStack(spacing: spacing){
                                        gridImage(index: 4, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                        
                                        gridImage(index: 5, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                    }
                                    
                                    gridImage(index: 6, widthMultiplier: 235/390, heightMultiplier: 112/390)
                                }
                               
                            }
                            
                            HStack(spacing: spacing){
                                gridImage(index: 7, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                
                                gridImage(index: 8, widthMultiplier: 112/390, heightMultiplier: 112/390)
                            }
                            
                            
                           
                        }
                    } else if posts.count == 10 {
                        VStack(alignment: .leading, spacing: spacing){
                            HStack(alignment: .top){
                                
                                gridImage(index: 0, widthMultiplier: 235/390, heightMultiplier: 235/390)
                                Spacer()
                                VStack{
                                    gridImage(index: 1, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                    Spacer()
                                    gridImage(index: 2, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                }.frame(height: width * 235/390)
                                
                            }
                            
                            HStack(alignment: .top, spacing: spacing){
                                gridImage(index: 3, widthMultiplier: 112/390, heightMultiplier: 235/390)
                                
                                VStack(spacing: spacing){
                                    HStack(spacing: spacing){
                                        gridImage(index: 4, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                        
                                        gridImage(index: 5, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                    }
                                    
                                    gridImage(index: 6, widthMultiplier: 235/390, heightMultiplier: 112/390)
                                }
                               
                            }
                            
                            HStack{
                                VStack(spacing: spacing){
                                    gridImage(index: 7, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                    
                                    gridImage(index: 8, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                }
                                
                                Spacer()
                                gridImage(index: 9, widthMultiplier: 233/390, heightMultiplier: 235/390)
                            }
                            
                            
                            
                           
                        }
                    } else if posts.count == 11 {
                        VStack(alignment: .leading, spacing: spacing){
                            HStack(alignment: .top){
                                
                                gridImage(index: 0, widthMultiplier: 235/390, heightMultiplier: 235/390)
                                Spacer()
                                VStack{
                                    gridImage(index: 1, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                    Spacer()
                                    gridImage(index: 2, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                }.frame(height: width * 235/390)
                                
                            }
                            
                            HStack(alignment: .top, spacing: spacing){
                                gridImage(index: 3, widthMultiplier: 112/390, heightMultiplier: 235/390)
                                
                                VStack(spacing: spacing){
                                    HStack(spacing: spacing){
                                        gridImage(index: 4, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                        
                                        gridImage(index: 5, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                    }
                                    
                                    gridImage(index: 6, widthMultiplier: 235/390, heightMultiplier: 112/390)
                                }
                               
                            }
                            
                            HStack{
                                VStack(spacing: spacing){
                                    gridImage(index: 7, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                    
                                    gridImage(index: 8, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                }
                                
                                Spacer()
                                gridImage(index: 9, widthMultiplier: 233/390, heightMultiplier: 235/390)
                            }
                            
                            gridImage(index: 10, widthMultiplier: 112/390, heightMultiplier: 112/390)
                            
                           
                        }
                    } else if posts.count == 12 {
                        VStack(alignment: .leading, spacing: spacing){
                            HStack(alignment: .top){
                                
                                gridImage(index: 0, widthMultiplier: 235/390, heightMultiplier: 235/390)
                                Spacer()
                                VStack{
                                    gridImage(index: 1, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                    Spacer()
                                    gridImage(index: 2, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                }.frame(height: width * 235/390)
                                
                            }
                            
                            HStack(alignment: .top, spacing: spacing){
                                gridImage(index: 3, widthMultiplier: 112/390, heightMultiplier: 235/390)
                                
                                VStack(spacing: spacing){
                                    HStack(spacing: spacing){
                                        gridImage(index: 4, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                        
                                        gridImage(index: 5, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                    }
                                    
                                    gridImage(index: 6, widthMultiplier: 235/390, heightMultiplier: 112/390)
                                }
                               
                            }
                            
                            HStack{
                                VStack(spacing: spacing){
                                    gridImage(index: 7, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                    
                                    gridImage(index: 8, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                }
                                
                                Spacer()
                                gridImage(index: 9, widthMultiplier: 233/390, heightMultiplier: 235/390)
                            }
                            
                            HStack(spacing: spacing){
                                gridImage(index: 10, widthMultiplier: 232/390, heightMultiplier: 112/390)
                                
                                gridImage(index: 11, widthMultiplier: 112/390, heightMultiplier: 112/390)
                            }
                            
                            
                           
                        }
                    } else if posts.count == 13 {
                        VStack(alignment: .leading, spacing: spacing){
                            HStack(alignment: .top){
                                
                                gridImage(index: 0, widthMultiplier: 235/390, heightMultiplier: 235/390)
                                Spacer()
                                VStack{
                                    gridImage(index: 1, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                    Spacer()
                                    gridImage(index: 2, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                }.frame(height: width * 235/390)
                                
                            }
                            
                            HStack(alignment: .top, spacing: spacing){
                                gridImage(index: 3, widthMultiplier: 112/390, heightMultiplier: 235/390)
                                
                                VStack(spacing: spacing){
                                    HStack(spacing: spacing){
                                        gridImage(index: 4, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                        
                                        gridImage(index: 5, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                    }
                                    
                                    gridImage(index: 6, widthMultiplier: 235/390, heightMultiplier: 112/390)
                                }
                               
                            }
                            
                            HStack{
                                VStack(spacing: spacing){
                                    gridImage(index: 7, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                    
                                    gridImage(index: 8, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                }
                                
                                Spacer()
                                gridImage(index: 9, widthMultiplier: 233/390, heightMultiplier: 235/390)
                            }
                            
                            HStack(spacing: spacing){
                                gridImage(index: 10, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                
                                gridImage(index: 11, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                
                                gridImage(index: 12, widthMultiplier: 112/390, heightMultiplier: 112/390)
                            }
                            
                            
                           
                        }
                    } else if posts.count == 14 {
                        VStack(alignment: .leading, spacing: spacing){
                            HStack(alignment: .top){
                                
                                gridImage(index: 0, widthMultiplier: 235/390, heightMultiplier: 235/390)
                                Spacer()
                                VStack{
                                    gridImage(index: 1, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                    Spacer()
                                    gridImage(index: 2, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                }.frame(height: width * 235/390)
                                
                            }
                            
                            HStack(alignment: .top, spacing: spacing){
                                gridImage(index: 3, widthMultiplier: 112/390, heightMultiplier: 235/390)
                                
                                VStack(spacing: spacing){
                                    HStack(spacing: spacing){
                                        gridImage(index: 4, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                        
                                        gridImage(index: 5, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                    }
                                    
                                    gridImage(index: 6, widthMultiplier: 235/390, heightMultiplier: 112/390)
                                }
                               
                            }
                            
                            HStack{
                                VStack(spacing: spacing){
                                    gridImage(index: 7, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                    
                                    gridImage(index: 8, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                }
                                
                                Spacer()
                                gridImage(index: 9, widthMultiplier: 233/390, heightMultiplier: 235/390)
                            }
                            
                            HStack (spacing: spacing){
                                VStack (spacing: spacing){
                                    HStack(spacing: spacing){
                                        gridImage(index: 10, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                        
                                        gridImage(index: 11, widthMultiplier: 112/390, heightMultiplier: 112/390)
                                        
                                        
                                    }
                                    
                                    gridImage(index: 12, widthMultiplier: 235/390, heightMultiplier: 112/390)
                                }
                                
                                gridImage(index: 13, widthMultiplier: 112/390, heightMultiplier: 235/390)
                            }
                            
                            
                           
                        }
                    }
                
                
            }.padding(.horizontal, width * 16/390)
            
            
        
    }
    
    @ViewBuilder
    func gridImage(index: Int, widthMultiplier: CGFloat, heightMultiplier: CGFloat) -> some View {
        
        let width = UIScreen.main.bounds.width
        
        if !navigateFromMain{
            NavigationLink(destination: 
                VariableView()
                .environmentObject(homeVM)
            .onAppear{
                homeVM.selectedVariableUploadId = posts[index].id
                homeVM.variableUplaods = posts
                homeVM.variablesTitle = variableTitle
                homeVM.variableSubTitle = variableSubtitle
            }
                           )
            {
                if let imageUrl = posts[index].imageUrls{
                    KFImage(URL(string: imageUrl[0]))
                        .resizable()
                        .scaledToFill()
                        .frame(width: width * widthMultiplier, height: width * heightMultiplier)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .contentShape(RoundedRectangle(cornerRadius: 16))
                        /*.overlay{
                            ZStack{
                                Color.black
                                Text("\(index)")
                                    .foregroundStyle(.white)
                            }
                        }*/
                        
                } else {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemGray6))
                        .frame(width: width * widthMultiplier, height: width * heightMultiplier)
                        
                }
            }
        } else {
            if let imageUrl = posts[index].imageUrls{
                KFImage(URL(string: imageUrl[0]))
                    .resizable()
                    .scaledToFill()
                    .frame(width: width * widthMultiplier, height: width * heightMultiplier)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .contentShape(RoundedRectangle(cornerRadius: 16))
                    .onTapGesture {
                        homeVM.selectedVariableUploadId = posts[index].id
                        homeVM.variableUplaods = posts
                        homeVM.variablesTitle = variableTitle
                        homeVM.variableSubTitle = variableSubtitle
                        homeVM.showVariableView = true
                    }
                    /*.overlay{
                        ZStack{
                            Color.black
                            Text("\(index)")
                                .foregroundStyle(.white)
                        }
                    }*/
                    
            } else {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemGray6))
                    .frame(width: width * widthMultiplier, height: width * heightMultiplier)
                    
            }
        }
        
       
        
        }
    
}


/*
#Preview {
    GridView(posts: .constant([Post.mockPosts[0], Post.mockPosts[0], Post.mockPosts[0], Post.mockPosts[0], Post.mockPosts[0], Post.mockPosts[0], Post.mockPosts[0], Post.mockPosts[0], Post.mockPosts[0], Post.mockPosts[0], Post.mockPosts[0], Post.mockPosts[0], Post.mockPosts[0], Post.mockPosts[0]]))
}*/
