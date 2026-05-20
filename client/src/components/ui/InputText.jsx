export default function InputText({
    placeholder,
    value,
    onChange,
    type = 'text',
    label,
    error,
    className,
    ...props
}) {
    return (
        <div className="mb-3">
            {label && (
                <label className="form-label fw-500">
                    {label}
                </label>
            )}
            <input
                type={type}
                className={`form-control ${error ? 'is-invalid' : ''} ${className || ''}`}
                placeholder={placeholder}
                value={value}
                onChange={onChange}
                {...props}
            />
            {error && (
                <div className="invalid-feedback d-block">
                    {error}
                </div>
            )}
        </div>
    );
}
