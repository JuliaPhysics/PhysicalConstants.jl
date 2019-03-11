Base.promote_rule(::Type{Constant{sym,S,D,SU}}, ::Type{Quantity{T,D,TU}}) where {sym,S,T,D,SU,TU} =
    promote_type(Quantity{S,D,SU}, Quantity{T,D,TU})
Base.promote_rule(::Type{Quantity{T,D,TU}}, ::Type{Constant{sym,S,D,SU}}) where {sym,S,T,D,SU,TU} =
    promote_type(Quantity{S,D,SU}, Quantity{T,D,TU})

Base.promote_rule(::Type{Constant{sym,S,NoDims,U}}, ::Type{T}) where {sym,S,U,T<:Number} =
    promote_type(S, T)
Base.promote_rule(::Type{Constant{sym,S,NoDims,U}}, ::Type{Quantity{T,NoDims,TU}}) where {sym,S,U,T,TU} =
    promote_type(S, T)

Base.convert(::Type{T}, x::Constant{sym,S,NoDims,U}) where {T<:AbstractFloat,sym,S,U} =
    float(T, x)

Unitful.uconvert(u::Unitful.Units, c::Constant{sym,T,D,TU}) where {sym,T,D,TU} =
    uconvert(u, float(T, c))
