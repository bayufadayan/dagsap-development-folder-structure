export default function TextLink({
    children,
    href = '#',
    className,
    variant = 'primary',
    ...props
}) {
    return (
        <a
            href={href}
            className={`text-decoration-none text-${variant} ${className || ''}`}
            {...props}
        >
            {children}
        </a>
    );
}
