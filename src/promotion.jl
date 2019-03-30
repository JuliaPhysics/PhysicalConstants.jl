Base.promote_rule(::Type{PhysicalConstant{name,S,D,SU}},
                  ::Type{Quantity{T,D,TU}}) where {name,S,T,D,SU,TU} =
                      promote_type(Quantity{S,D,SU}, Quantity{T,D,TU})
Base.promote_rule(::Type{Quantity{T,D,TU}},
                  ::Type{PhysicalConstant{name,S,D,SU}}) where {name,S,T,D,SU,TU} =
                      promote_type(Quantity{S,D,SU}, Quantity{T,D,TU})

Base.promote_rule(::Type{PhysicalConstant{name,S,NoDims,U}},
                  ::Type{T}) where {name,S,U,T<:Number} =
                      promote_type(S, T)
Base.promote_rule(::Type{PhysicalConstant{name,S,NoDims,U}},
                  ::Type{Quantity{T,NoDims,TU}}) where {name,S,U,T,TU} =
                      promote_type(S, T)

Base.convert(::Type{T},
             x::PhysicalConstant{name,S,NoDims,U}) where {T<:AbstractFloat,name,S,U} =
                 float(T, x)

Unitful.uconvert(u::Unitful.Units, c::PhysicalConstant{name,T,D,TU}) where {name,T,D,TU} =
    uconvert(u, float(T, c))
